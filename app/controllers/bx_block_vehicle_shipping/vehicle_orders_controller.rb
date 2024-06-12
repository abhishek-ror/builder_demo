module BxBlockVehicleShipping
  class VehicleOrdersController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

      before_action :validate_json_web_token
      before_action :set_current_user
      include ActiveStorage::SetCurrent

      def create
        get_buyer_params = create_params
        if get_buyer_params["country_code"].present? && get_buyer_params["phone_number"].present?
          get_buyer_params[:full_phone_number] = get_buyer_params["country_code"] + get_buyer_params["phone_number"]
        end
        phone_validator = valid_phone_number(get_buyer_params[:full_phone_number])
        return render json: {error: "Phone Number Invalid"}, status: 422 if phone_validator.present?
      
          buy_request = BxBlockVehicleShipping::VehicleOrder.new(get_buyer_params.merge({account_id: @current_user.id, status: 1}))
        if buy_request.save
        render json: BxBlockVehicleShippings::VehicleOrderSerializer.new(buy_request, meta: {
                message: "Your details have been submitted to the admin,they will contact you shortly"
                    }).serializable_hash, status: :ok
        else
          render json: {
                errors: format_activerecord_errors(buy_request.errors)
              }, status: :unprocessable_entity
        end
      end

    def get_order
      if params[:order_request_id].present?
        @car_order = BxBlockVehicleShipping::VehicleOrder.find_by(account_id: @current_user.id, order_request_id: params[:order_request_id])
        render json: {status: 200, data: BxBlockVehicleShippings::VehicleOrderSerializer.new(@car_order, params: {current_user_id: current_user.id}).serializable_hash}, status: 200
      else
        render json: {status: 422, message: 'Required inputs missing'}, status: 422
      end
    end


    def get_purchased
      if params[:status] == "in_transit"
        get_lists = BxBlockVehicleShipping::VehicleOrder.where(status: [6,7,8],account_id: current_user.id)  
      elsif params[:status] == "interested"
        get_lists = BxBlockVehicleShipping::VehicleOrder.where(status: [1,3,4,11],account_id: current_user.id)
      elsif params[:status] == "delivered"
        get_lists = BxBlockVehicleShipping::VehicleOrder.where(status: 9,account_id: current_user.id)  
      elsif params[:status] == "cancelled"
        get_lists = BxBlockVehicleShipping::VehicleOrder.where(status: 2,account_id: current_user.id)
      else
        return render json: {error: "Invalid Parameters"},status: :unprocessable_entity
      end
      return render json: {data: BxBlockVehicleShippings::VehicleOrderSerializer.new(get_lists, params:{get_purchased: true}), status: 200} if get_lists.present?
      return render json: {data: "orders not available", status: 404} if get_lists.blank? 
    end


    def request_inspection
      ActiveRecord::Base.transaction do 
        @car_order = BxBlockVehicleShipping::VehicleOrder.find_by(account_id: @current_user.id, order_request_id: params[:order_request_id])
        unless  @car_order.present?
          if params[:selling_id].present?
           @car_order = BxBlockVehicleShipping::VehicleOrder.create(vehicle_selling_id: params[:selling_id], country: @current_user.country, country_code: @current_user.country_code, phone_number: @current_user.phone_number, account_id: @current_user.id)
          elsif params[:car_ad_id].present?
            @car_order = BxBlockVehicleShipping::VehicleOrder.create(car_ad_id: params[:car_ad_id], country: @current_user.country, country_code: @current_user.country_code, phone_number: @current_user.phone_number, account_id: @current_user.id)
          end
        end
        if @car_order.present?
          @car_order.update(status: "inspection requested") if params[:order_request_id].present?
          if @car_order.vehicle_selling_id.present?
            car_ad = @car_order&.vehicle_selling
            car_ad_type = "vehicle_selling"
            year = car_ad.year
          elsif @car_order.car_ad_id.present?
            car_ad = @car_order&.car_ad
            car_ad_type = "car_ad"
            year = car_ad.make_year
          end
          inspection_charge = BxBlockRateCard::InspectionCharge.where("lower(country) = ?", car_ad.city.state.country.name.downcase).try(:first)&.price
          report_available = BxBlockAdmin::VehicleInspection.exists?(car_ad_id: car_ad.id, status: 'completed')
          model_id = car_ad&.trim.model
            attr = {
              city_id: car_ad&.city_id,
              model: model_id,
              account_id: @car_order&.account_id,
              make_year: year,
              seller_mobile_number: @car_order.full_phone_number,
              inspection_amount: inspection_charge,
              car_ad_id: car_ad.id,
              car_ad_type: car_ad_type,
              final_sale_amount: @car_order.final_sale_amount,
              instant_deposit_amount: @car_order.instant_deposit_amount,
              price: car_ad&.price.to_f
            }     
          @car_vehicle_inspection = BxBlockAdmin::VehicleInspection.create(attr)
          @car_order.update(vehicle_inspection_id: @car_vehicle_inspection.id, status: 3) if @car_order.present?
          return render json: {success: false, message: 'Payment already completed for this item'}, status: 422 if @car_vehicle_inspection.payment_confirmed? || @car_vehicle_inspection.accepted_for_inspection?
          return render json: {success: false, message: 'Please update Inspection amount'}, status: 422 if @car_vehicle_inspection.inspection_amount.to_f <= 0.0
          @car_vehicle_inspection.inprogress!
          stripe_card_id =  BxBlockPayments::CreditCardService.new(@token.id, card_params).create_credit_card
          car_ad.update(is_inspected: true)
          stripe_service = BxBlockPayments::StripeIntegrationService.new(@current_user.id)
          # stripe_service.stripe_charge(payment_attributes.merge(stripe_card_id: stripe_card_id))
          payment_response = stripe_service.stripe_payment_intent(payment_attributes.merge(stripe_card_id: stripe_card_id))
          if payment_response&.id.present?
            @car_vehicle_inspection.payment_confirmed!

            BxBlockPayments::PaymentTransaction.create(account_id: @current_user.id, target_type: 'BxBlockAdmin::VehicleSellingInspection', target_id: @car_vehicle_inspection.id, status: 0, payload: payment_attributes.merge(stripe_card_id: stripe_card_id), transaction_id: payment_response&.id)
              render json: {success: true, url: '', payment_id: payment_response&.id, payment_message: "Payment confirmed", message: "you will receive a notification regarding the inspection report."}, status: 200
          else
            @car_vehicle_inspection.payment_failed!
            render json: {success: false, message: 'Unable to initiate payment process due to the car not existing'}, status: 422
          end
        else
          return render json: {status: 422, message: 'Invalid order details'}, status: 422
        end
      end
    end 

    def get_order_details
      if params[:order_request_id].present?
        @car_order = BxBlockVehicleShipping::VehicleOrder.find_by(account_id: @current_user.id, order_request_id: params[:order_request_id])
        if @car_order.vehicle_shipping_id.present?
          vehicle_inspection = @car_order.vehicle_inspection
          @shipment = BxBlockVehicleShipping::VehicleShipping.find_by_id(@car_order.vehicle_shipping_id)
          render json: {status: 200, data: BxBlockVehicleShippings::VehicleOrderSerializer.new(@car_order, params: {current_user_id: current_user.id, get_purchased: true}).serializable_hash, shipment: BxBlockVehicleShippings::VehicleShippingSerializer.new(@shipment).serializable_hash, vehicle_inspection: BxBlockPosts::VehicleInspectionSerializer.new(vehicle_inspection, serialization_options).serializable_hash.deep_transform_values{|attribute| attribute.to_s}}, status: 200
        else
          vehicle_inspection = @car_order.vehicle_inspection
          render json: {status: 200, data: BxBlockVehicleShippings::VehicleOrderSerializer.new(@car_order, params: {current_user_id: current_user.id, get_purchased: true}).serializable_hash, shipment: {}, vehicle_inspection: BxBlockPosts::VehicleInspectionSerializer.new(vehicle_inspection, serialization_options).serializable_hash.deep_transform_values{|attribute| attribute.to_s}}, status: 200
        end
      else
        render json: {status: 422, message: 'Required inputs missing'}, status: 422
      end
    end


    def upload_document
      order = BxBlockVehicleShipping::VehicleOrder.find_by(account_id: @current_user.id, order_request_id: document_params[:order_request_id])
      if order.present?
        buy_request = order
        order.update(document_params.merge(final_invoice_payment_status: 'submitted'))
        if order.vehicle_selling.present?
          car = order.vehicle_selling
          vehicle_shipment = BxBlockVehicleShipping::VehicleShipping.create(model: car.trim.model.name, make: car.trim.name, country: car.city.state.country.name, area: car.city.name, region: car.region.name, state: car.state.name, year: car.year, regional_specs: car.regional_spec, account_id: order.account_id, source_country: car.country.name, destination_country: order.country, approved_by_admin: true)
        elsif order.car_ad.present?
          car = order.car_ad
          vehicle_shipment = BxBlockVehicleShipping::VehicleShipping.create(model: car.model.name, make: car.trim.name, country: car.city.state.country.name, area: car.city.name, region: car.city.state.country.region.name, state: car.city.state.name, year: car.make_year, regional_specs: car&.regional_specs&.last&.name, account_id: order.account_id, source_country: car.city.state.country.name, destination_country: order.country, approved_by_admin: true)
        end
        BxBlockPushNotifications::PushNotification.where(account_id: order.account_id, notification_type_id: order.order_request_id).update_all(completion_check: true)
        order.update(vehicle_shipping_id: vehicle_shipment.id)
        render json: {
          data: BxBlockVehicleShippings::VehicleOrderSerializer.new(order).serializable_hash,
          status: 200,
          message: "Documents Submitted Successfully You will Receive Notification Regarding Shipment details.."
        }, status: 200
      else
        render json: { error: "Order Not Found", status: 404 }    
      end
    end


    def get_documents
      documents = BxBlockVehicleShipping::VehicleOrder.where(account_id: @current_user.id, order_request_id: params[:order_request_id] )
      if documents.present?
        render json: {order_details: BxBlockVehicleShippings::VehicleOrderSerializer.new(documents).serializable_hash }
      else
        render json: { message: "Order not Found" },status: 404
      end
    end
    
      def order_cancelled
        order = BxBlockVehicleShipping::VehicleOrder.where(account_id: @current_user.id, order_request_id: params[:order_request_id] )
        if order.present?
          if order.update(status: "cancelled")
            BxBlockPushNotifications::PushNotification.where(account_id: @current_user.id, notification_type_id: params[:order_request_id]).destroy_all
            render json: { 
                      message: "order request cancelled successfully..",
                      order: order
                    }
          end
        else
          render json: {message: "order request not found"},status: 404
        end
      end
      private 

      def set_current_user
        @current_user ||= AccountBlock::Account.find_by(id: @token.id)
        return render json: {errors: 'Account Not Found'}, :status => :not_found if @current_user.blank?
      end

     def valid_phone_number full_phone_number
        unless Phonelib.valid?(full_phone_number)
          "Invalid or Unrecognized Phone Number"
        end
      end

    def document_params
      params.require(:data).permit(:payment_receipt, :passport, :notes, :order_request_id, :instant_deposit_status, :final_invoice_payment_status, :other_documents => [])
    end
      def create_params
          params.require(:data).permit(:continent, :country, :state, :area, :country_code, :phone_number, :full_phone_number, :vehicle_selling_id, :car_ad_id)
      end

      def payment_attributes
        {
          amount: @car_vehicle_inspection.inspection_amount,
          currency: 'usd',
          description: 'Vehicle Inspection charge',
          metadata: {type: 'BxBlockAdmin::VehicleSellingInspection', id: @car_vehicle_inspection.id, name: 'Inspection Payment'},
        }
      end

    def card_params
     params.require(:card).permit(:number, :month, :year, :cvc)
    end
    def serialization_options
      options = {}
      options[:params] = {}
      options
    end
  end
end
