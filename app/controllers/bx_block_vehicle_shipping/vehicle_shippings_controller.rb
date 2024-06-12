module BxBlockVehicleShipping
  class VehicleShippingsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token
    before_action :current_user

    def create
      shipment = BxBlockVehicleShipping::VehicleShipping.new(update_params)
      shipment.account_id = current_user.id
      shipment.status = 'ongoing'
      if shipment.save!
        render json: { 
          Message: "shipment created successfully",
          shipment: BxBlockVehicleShippings::VehicleShippingSerializer.new(shipment).serializable_hash
        },status: 200
      else
        render json: {errors: format_activerecord_errors(shipment.errors)},status: :unprocessable_entity
      end
    end

    def show
      @shipment = BxBlockVehicleShipping::VehicleShipping.find_by_id(params[:id])
      @destination = BxBlockRateCard::DestinationHandling.find_by_destination_country(@shipment.destination_country)
      @charge =  BxBlockRateCard::ShippingCharge.where(source_country:@shipment.source_country,destination_country:@shipment.destination_country).first
      if @destination.present? and @shipment.present? and @charge.present?
        destination_charge = []
        destination_charge << @destination.unloading
        destination_charge << @destination.customs_clearance
        destination_charge << @destination.storage
        destination_charge << @charge.price
        other_charge =  destination_charge.map(&:to_i).take(3).sum
        final_charges = destination_charge.reduce(0) {|total, element| total + element.to_i} 
        @shipment.update!(final_shipping_amount:final_charges,other_charge:other_charge,final_destination_charge:@charge.price)
        return render json: {shipment: BxBlockVehicleShippings::VehicleShippingSerializer.new(@shipment).serializable_hash}, status: 200 if @shipment.present?
      end
        render json: {shipment: "Shipment/Destination not Found"},status: 404 
    end

    def place_order
      shipment = BxBlockVehicleShipping::VehicleShipping.find_by_id(params[:shipment_id])
      if shipment.present?
         shipment.update!(order_placed:'true')
         render json: {message: "Your request has been placed.Admin will update final shipping amount in the next 24 hours"},status: 200 
      else
         render json: {shipment: "Shipment not Found"},status: 404 
      end
    end

    def complete_tracking_order
      resource = BxBlockVehicleShipping::VehicleShipping.find_by_id(params[:id])
      BxBlockPushNotifications::PushNotification.where(account_id: resource.account_id, notification_type_id: resource.id).update_all(completion_check: true)
      render json: {shipment: "notification updated"},status: 200
    end

    def upload_customer_receipt
      shipment = BxBlockVehicleShipping::VehicleShipping.find_by_id(params[:data][:shipment_id])
      if shipment.present?
       shipment.update(document_params)
       BxBlockPushNotifications::PushNotification.where(account_id: shipment.account_id, notification_type_id: shipment.id).update_all(completion_check: true)
       render json: {shipment: "Customer Receipt Uploaded"},status: 200 
      else
        render json: {shipment: "Shipment or receipt is missing"},status: 422
      end
    end

    def get_proof_of_delivery
      shipment = BxBlockVehicleShipping::VehicleShipping.find_by_id(params[:id])
      review_given = BxBlockReviews::AppReview.find_by(account_id: current_user.id).present?
      if shipment.present?
       render json: {status: 200, shipment: shipment.delivery_proof&.attached? ? shipment.delivery_proof.map{|doc| doc.service_url} : [], review_given: review_given},status: 200 
      else
        render json: {shipment: "Shipment or receipt is missing"},status: 422
      end
    end

    def order_details
      shipment = BxBlockVehicleShipping::VehicleShipping.find_by_id(params[:id])
      if shipment.present?
       render json: {status: 200, order_id: shipment.order_request_id, invoice_amount: shipment.invoice_amount, payment_link: shipment.payment_link, invoice: shipment.delivery_invoice&.attached? ? url_for(shipment.delivery_invoice): ""},status: 200 
      else
        render json: {shipment: "Shipment or receipt is missing"},status: 422
      end
    end

    def upload_receipt
      shipment = BxBlockVehicleShipping::VehicleShipping.find_by_id(params[:shipment_id])
      if shipment.present? and params[:receipt].present?
       shipment.payment_receipt.attach(params[:receipt])
       render json: {shipment: "Receipt Uploaded"},status: 200 
      else
        render json: {shipment: "Shipment or receipt is missing"},status: 422
      end
    end

    def all_country
      country = BxBlockAdmin::Country.all
      render json: {country: country.as_json(only: [:id, :name])},status: 200
    end

    def port
      country = BxBlockAdmin::Country.find_by_id(params[:country_id])
      ports = country&.ports
      render json: {ports: ports.as_json(only: [:id, :port_name])},status: 200
    end

    def update
      shipment = BxBlockVehicleShipping::VehicleShipping.find_by_id(params[:id])       
      if shipment && shipment.update(update_params)
        BxBlockPushNotifications::PushNotification.where(account_id: shipment.account_id, remarks: "Notification regarding final shipping amount.", notification_type_id: shipment.id).update_all(completion_check: true)
        render json: {
          message: "shipment updated successfully..",
          shipment: BxBlockVehicleShippings::VehicleShippingSerializer.new(shipment).serializable_hash
        },status: 200

      else
        render json: {
          error: "Invalid Id" 
        }, status: :unprocessable_entity
      end 
    end

    def get_user_shipment_list
      shipments = BxBlockVehicleShipping::VehicleOrder.where(account_id: current_user.id).where.not(vehicle_shipping_id: nil).map{|x| x.vehicle_shipping}
      return render json: {
        shipments: BxBlockVehicleShippings::VehicleShippingSerializer.new(shipments).serializable_hash
      }, status: 200 if shipments.present?
      render json: {shipment: "Shipments not Found"}, status: 200 if shipments.blank?
    end

    def shipping_cancelled
      shipping = BxBlockVehicleShipping::VehicleShipping.find(params[:id])
      if shipping.present?
        if shipping.status == "cancelled"
        render json: {
                    message: "Your order has been cancelled",
                    shipping: BxBlockVehicleShippings::VehicleShippingSerializer.new(shipping).serializable_hash
                  }, status: 200
        end
      else
        render json: {message: "shipping not found"},status: 404
      end
    end

    def get_final_invoice
      shipping = BxBlockVehicleShipping::VehicleShipping.find_by_id(params[:id])
      shipping_data = []
      shipping_data << shipping&.export_title
      shipping_data << shipping&.shipping_invoice
      return render json: { shipping: BxBlockVehicleShippings::VehicleShippingSerializer.new(shipping).serializable_hash}, status: 200  if shipping.present?
      render json: {shipment: "shipping not Found"}, status: 200 if shipping.blank?
    end
    
    def admin_notes
      shipping = BxBlockVehicleShipping::VehicleShipping.find_by_id(params[:id])
      if shipping.present?
        if params[:data][:notes_for_admin].present?
          shipping.update!(notes_for_admin: params[:data][:notes_for_admin])
        end  
        if params[:data][:other_documents].present?
          shipping.update!(other_documents: params[:data][:other_documents])          
        end
        BxBlockPushNotifications::PushNotification.where(account_id: shipping.account_id, notification_type_id: shipping.id).update_all(completion_check: true)
        render json: {
            Message: "notes for admin & Other documents updated successfully",
            shipping: BxBlockVehicleShippings::VehicleShippingSerializer.new(shipping).serializable_hash
          },status: 200
      else
        render json: {Message: "notes for admin and other docuemnts are not found !"}
      end  
    end

    private
  
    def document_params
      params.require(:data).permit(:customer_payment_receipt => [])
    end
    def update_params
      params.require(:data).permit(:region, :country, :state, :area, :year, :make, :model, :regional_specs, :country_code, :phone_number, :source_country, :pickup_port, :destination_country, :destination_port, :shipping_instruction, :export_certificate, :passport, :tracking_number, :export_title, :payment_type, :payment_receipt, :shipping_invoice, :delivery_invoice, :conditional_report, :customer_payment_receipt => [], :condition_pictures => [], :delivery_proof => [], :car_images => [], :other_documents => [])
    end
  end
end