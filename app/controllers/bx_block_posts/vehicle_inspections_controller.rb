module BxBlockPosts
  class VehicleInspectionsController < ApplicationController
    before_action :load_inspection, only: [:show, :update, :destroy, :update_acceptance_status, :payment, :update_instant_deposit_status, :inspection_report, :inspection_payment_details]
    before_action :validate_json_web_token
    before_action :set_current_user
    before_action :store_in_memory, only: [:notification]

    rescue_from ActiveRecord::RecordNotFound, :with => :not_found

    def create
      if params[:vehicle_inspection].present?
        # added a new create
        vehicle_inspection = BxBlockAdmin::VehicleInspection.new(vehicle_inspection_params.merge(account_id: @current_user.id, status: 0))
        if vehicle_inspection.save
          handle_create_images(vehicle_inspection)
          store_in_memory(vehicle_inspection)
          @car_vehicle_inspection = vehicle_inspection
          payment
        else
          render json: {success: false, message: 'Required inputs missing'}, status: 422
        end
      end
    end

    def store_device_id
      @current_user.update(device_id: params[:device_id])
    end

    def show_notification
      push_notification = AccountBlock::Account.find(@current_user.id).push_notifications.order(created_at: :desc)
      if push_notification.blank?
        render json: { message: "Push Notification Not Found" },
        status: :not_found
      else
        render json: BxBlockPushNotifications::PushNotificationSerializer.new(push_notification)
      end
    end

    def unread_notification 
      push_notification = AccountBlock::Account.find(@current_user.id).push_notifications.where(is_read: false).order(created_at: :desc)
      if push_notification.blank?
        render json: { message: "Push Notification Not Found" },
        status: :not_found
      else
        render json: BxBlockPushNotifications::PushNotificationSerializer.new(push_notification)
      end
    end

    def unread_notification_count
      push_notification_count = AccountBlock::Account.find(@current_user.id).push_notifications.where(is_read: false).count
      render json: {count: push_notification_count}
    end

    def read_notification
      if @current_user.present?
        if params[:id].present?
          notification = BxBlockPushNotifications::PushNotification.find_by(id: params[:id])
          if notification.present?
            notification.update(is_read: true)
            render json: { message: "notification updated" }
          end
        else
          push_notifications = AccountBlock::Account.find(@current_user.id).push_notifications.order(created_at: :asc)
          push_notifications.update_all(is_read: true)
          render json: { message: "notifications updated" }
        end
      end
    end

    def show
      return if @car_vehicle_inspection.blank?

      render json: BxBlockPosts::VehicleInspectionSerializer.new(@car_vehicle_inspection, serialization_options)
                       .serializable_hash.deep_transform_values{|attribute| attribute.to_s},
             status: :ok
    end

    def index
      vehicle_inspections = @current_user.inspector_inspections
      if params[:status].present?
        vehicle_inspections = vehicle_inspections.where(status: params[:status])
      end
      serializer = BxBlockPosts::VehicleInspectionSerializer.new(vehicle_inspections, serialization_options).serializable_hash.deep_transform_values{|attribute| attribute.to_s}
      render json: serializer, status: :ok
    end


    def show_inspection
      vehicle_inspections = @current_user.inspector_inspections.find_by(id: params[:id])
      serializer = BxBlockPosts::VehicleInspectionSerializer.new(vehicle_inspections, serialization_options).serializable_hash.deep_transform_values{|attribute| attribute.to_s}
      render json: serializer, status: :ok
    end

    def my_inspections
      vehicle_inspections = @current_user.vehicle_inspections.where.not(car_ad_id: nil)
      if params[:status].present?
        vehicle_inspections = vehicle_inspections.where(status: params[:status])
      end
      serializer = BxBlockPosts::VehicleInspectionSerializer.new(vehicle_inspections, serialization_options).serializable_hash.deep_transform_values{|attribute| attribute.to_s}
      render json: serializer, status: :ok
    end


    def destroy
      begin
        if @car_vehicle_inspection.destroy
          render json: { success: true }, status: :ok
        end
      rescue ActiveRecord::InvalidForeignKey
        message = "Record can't be deleted due to reference to a others " \
                  "record"
        render json: {
          error: { message: message }
        }, status: :internal_server_error
      end
    end

    def update
      if @car_vehicle_inspection.update(vehicle_inspection_update_params)
        @car_vehicle_inspection.update(status: 5)
        if @current_user.id == @car_vehicle_inspection.inspector_id
          BxBlockPushNotifications::PushNotification.where(account_id: @car_vehicle_inspection.inspector_id,notification_type_id: @car_vehicle_inspection.id).update_all(completion_check: true)
        end
        BxBlockPushNotifications::PushNotification.where(account_id: @car_vehicle_inspection.account_id, notification_type_id: @car_vehicle_inspection.id).where.not(remarks: "Notification regarding the shipment of the car").update_all(completion_check: true)
        render json: BxBlockPosts::VehicleInspectionSerializer.new(@car_vehicle_inspection).serializable_hash.deep_transform_values{|attribute| attribute.to_s},
               status: :ok
      else
        render json: ErrorSerializer.new(@car_vehicle_inspection).serializable_hash,
               status: :unprocessable_entity
      end
    end

    def get_inspection_amount
      inspection_charge = BxBlockRateCard::InspectionCharge.where("lower(country) = ?", params[:country].downcase).try(:first)
      render json: {amount: inspection_charge&.price, success: true}, status: 200
    end

    def payment
      success = validate_card_details(card_params['number'],card_params['month'],card_params['year'],card_params['cvc'])
      if @car_vehicle_inspection.car_ad_id.present?
        @car_order = BxBlockVehicleShipping::VehicleOrder.create(car_ad_id: @car_vehicle_inspection.car_ad_id, country: @current_user.country, country_code: @current_user.country_code, phone_number: @current_user.phone_number, account_id: @current_user.id, vehicle_inspection_id: @car_vehicle_inspection.id)
        BxBlockAdmin::CarAd.find_by(id: @car_vehicle_inspection.car_ad_id).update(is_inspected: true)
      end
      unless success.nil?
        @car_vehicle_inspection.delete
        return render json: {success: false, message: success}, status: 422 
      end
      @car_vehicle_inspection.inprogress!
      stripe_card_id = 
        if params[:card_id].present?
          params[:card_id]
        else
          @car_vehicle_inspection.payment_pending!
          BxBlockPayments::CreditCardService.new(@current_user.id, card_params).create_credit_card
        end

      stripe_service = BxBlockPayments::StripeIntegrationService.new(@current_user.id)
      # stripe_service.stripe_charge(payment_attributes.merge(stripe_card_id: stripe_card_id))
      payment_response = stripe_service.stripe_payment_intent(payment_attributes.merge(stripe_card_id: stripe_card_id))

      if payment_response&.id.present?
        # action_type = payment_response.next_action.use_stripe_sdk.type
        # auth_url = nil
        # if action_type == 'three_d_secure_redirect'
        #   auth_url = payment_response.next_action.use_stripe_sdk.stripe_js
        # end
        @car_vehicle_inspection.payment_confirmed!
        BxBlockPayments::PaymentTransaction.create(account_id: @current_user.id, target_type: 'BxBlockAdmin::VehicleInspection', target_id: @car_vehicle_inspection.id, status: 0, payload: payment_attributes.merge(stripe_card_id: stripe_card_id), transaction_id: payment_response&.id)
        render json: {success: true, url: '', payment_id: payment_response&.id, payment_message: "Payment confirmed", message: "you will receive a notification regarding the inspection report."}, status: 200
      else
        @car_vehicle_inspection.payment_failed!
        @car_vehicle_inspection.delete
        render json: {success: false, message: 'Unable to initiate payment process due to the car not existing'}, status: 422
      end
    end

    def update_acceptance_status
      if @car_vehicle_inspection.update(acceptance_status: params[:status])
          if @car_vehicle_inspection.vehicle_order.present?
            status = params[:status] == 'buy' ? 'pre booked' : 'closed'
            @car_vehicle_inspection.vehicle_order.update(status: status)
          end
           BxBlockPushNotifications::PushNotification.where(account_id: @car_vehicle_inspection.account_id, notification_type_id: @car_vehicle_inspection.id).update_all(completion_check: true)
        render json: BxBlockPosts::VehicleInspectionSerializer.new(@car_vehicle_inspection, serialization_options)
                       .serializable_hash.deep_transform_values{|attribute| attribute.to_s}, status: :ok
      else
        render json: {success: false, message: 'Unable to update status'}, status: 422
      end
    end

    def update_instant_deposit_status
      if @car_vehicle_inspection.update(vehicle_inspection_params)
        render json: BxBlockPosts::VehicleInspectionSerializer.new(@car_vehicle_inspection, serialization_options)
                       .serializable_hash.deep_transform_values{|attribute| attribute.to_s}, status: :ok
      else
        render json: {success: false, message: 'Unable to submit. Please try again.'}, status: 422
      end
    end

    def inspection_report
      if @car_vehicle_inspection.car_ad_id.present?
        vehicle_inspection = BxBlockAdmin::VehicleInspection.joins(:inspection_report).where(car_ad_id: @car_vehicle_inspection.car_ad_id, status: 'completed').last
        inspection_report = vehicle_inspection&.inspection_report
      else
        inspection_report = @car_vehicle_inspection.inspection_report
      end
      inspection_invoice = if Rails.env.development? || Rails.env.test?
        Rails.application.routes.url_helpers.rails_blob_path(@car_vehicle_inspection.inspection_invoice, only_path: true) if @car_vehicle_inspection.inspection_invoice.attached?
      else
        @car_vehicle_inspection.inspection_invoice.attached? ? @car_vehicle_inspection.inspection_invoice.service_url : nil
      end
    
      render json: {
        status: 200, 
        data: BxBlockPosts::VehicleInspectionReportSerializer.new(inspection_report).serializable_hash.deep_transform_values{|attribute| attribute.to_s}, inspection_invoice: inspection_invoice, acceptance_status: @car_vehicle_inspection.acceptance_status
      }, status: 200
    end

    def payment_status
      if params[:transaction_id].present?
        transaction = BxBlockPayments::PaymentTransaction.find_by(account_id: @current_user.id, transaction_id: params[:transaction_id])
        return render json: {status: 422, message: 'Invalid transaction'}, status: 422 if transaction.blank?

        render json: {status: 200, payment_success: transaction.completed? }, status: 200
      else
        render json: {status: 422, message: 'Required Input missing'}, status: 422
      end
    end
    
    def inspection_payment_details
      order_payment_details = {"order_id" => @car_vehicle_inspection&.car_order&.order_request_id, "inspection_ammount" => @car_vehicle_inspection.inspection_amount, "total" => @car_vehicle_inspection.inspection_amount}
      render json: { order_payment_details: order_payment_details }, status: 200
    end

    def create_vehicle_inspection

      if params[:vehicle_inspection].present?
        @car_ad = BxBlockAdmin::CarAd.find_by(id: params[:vehicle_inspection][:car_ad_id])
        if @car_ad.nil?
          return render json: {
              message: "CarAd with id #{params[:id]} doesn't exists", status: 404
          }, status: :not_found
        end
        vehicle_inspection = BxBlockAdmin::VehicleInspection.new(vehicle_inspection_data.merge(account_id: @current_user.id, status: 0, city_id: @car_ad.city_id, model_id: @car_ad.model&.id, price: @car_ad.price, make_year: @car_ad.make_year))
        if vehicle_inspection.save
          add_image(vehicle_inspection)
          # BxBlockPushNotifications::PushNotification.send_push_notification(vehicle_inspection, "add new notification", "Push notification")
          store_in_memory(vehicle_inspection)
          @car_vehicle_inspection = vehicle_inspection
          payment
        else
          return render json: {success: false, message: vehicle_inspection.errors.full_messages.join}, status: :unprocessable_entity
        end
      else
        render json: {success: false, message: 'Required inputs missing'}, status: 422
      end
    end

    private

    def add_image(vehicle_inspection)
      if @car_ad.images.present?
        @car_ad.images.each do |image|
          file_name = image.image_url.split("/").last
          file_location = Rails.root.join('spec', 'fixtures', 'myfiles', file_name)
          IO.copy_stream(URI.open(image.image_url), file_location)
          if File.exist?(file_location)
            temfile = Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'myfiles', file_name), 'image/jpeg')
            vehicle_inspection.images.create(image: temfile) 
            File.delete(Rails.root.join(file_location)) unless file_name.include?("bmw.jpeg")
          end
          #vehicle_inspection.auto_images.attach(io: img, filename: image.image_url.split("/").last)
        end
      end
    end

    def store_in_memory(vehicle_inspection)
      # BxBlockPushNotifications::PushNotification.create(account_id: vehicle_inspection.inspector_id, remarks: "Your inspection request has been scheduled", notify_type: "Inspection Report", push_notificable_id: vehicle_inspection.inspector_id, push_notificable_type: "AccountBlock::Account", is_read: false, logo: @base_url)
    end

    def notification(vehicle_inspection)
    end

    def handle_create_images(data)
      if params["vehicle_inspection"]["image_attributes"].present?
        params["vehicle_inspection"]["image_attributes"]["images"]&.each do |image|
          data.images.create(:image=> image)
        end
      end
    end
    
    def vehicle_inspection_data
      params.require(:vehicle_inspection).permit(:car_ad_id,:advertisement_url,:regional_spec, :inspector_id, :account_id, :model_id, :city_id, :inspection_amount, :final_sale_amount, :notes_for_the_inspector, :status,
        :car_ad_type)
    end

    def vehicle_inspection_params
      params.require(:vehicle_inspection).permit(:car_ad_id,:advertisement_url,:regional_spec, :inspector_id, :account_id, :model_id, :city_id, :make_year, :about, :instant_deposit_amount, :final_sale_amount,
        :price,:seller_mobile_number, :seller_country_code, :seller_email, :seller_name, :inspection_amount, :instant_deposit_link, :car_ad_type,
        :notes_for_the_inspector, :notes_for_the_admin, :status, :final_invoice_status, :instant_deposit_status, 
        :instant_deposit_receipt, :document, :payment_receipt, :notes_for_the_admin, other_documents_attributes: [:id, :image, :item_type],
        inspection_report_attributes: [:id, :google_drive_url, inspection_forms_attributes: [:id, :image, :item_type], 
        reports_attributes: [:id, :image, :item_type], images_attributes: [:id, :image, :item_type]]
      ).merge!({vin_number: params[:vehicle_inspection][:regional_spec]})
    end

    def vehicle_inspection_update_params
      params.require(:vehicle_inspection).permit(:car_ad_id,:advertisement_url, :inspector_id, :account_id, :model_id, :city_id, :make_year, :about, :instant_deposit_amount, :final_sale_amount,
        :price,:seller_mobile_number, :seller_country_code, :seller_email, :seller_name, :inspection_amount, :instant_deposit_link, :car_ad_type,
        :notes_for_the_inspector, :notes_for_the_admin, :status, :final_invoice_status, :instant_deposit_status, 
        :instant_deposit_receipt, :document, :payment_receipt, :notes_for_the_admin, other_documents_attributes: [:id, :image, :item_type],
        inspection_report_attributes: [:id, :google_drive_url, inspection_forms_attributes: [:id, :image, :item_type], 
        reports_attributes: [:id, :image, :item_type], images_attributes: [:id, :image, :item_type]]
      )
    end

    def card_params
      params.require(:card).permit(:number, :month, :year, :cvc)
    end

    def payment_attributes
      {
        amount: @car_vehicle_inspection.inspection_amount,
        currency: 'usd',
        description: 'Vehicle Inspection charge',
        metadata: {type: 'BxBlockAdmin::VehicleInspection', id: @car_vehicle_inspection.id, name: 'Inspection Payment'},
      }
    end

    def load_inspection
      @car_vehicle_inspection = BxBlockAdmin::VehicleInspection.find_by(id: params[:id])

      if @car_vehicle_inspection.blank?
        render json: {
            message: "Car Vehicle Inspection with id #{params[:id]} doesn't exists"
        }, status: :not_found
      end
    end

    def serialization_options
      options = {}
      options[:params] = {}
      options
    end

    def not_found
      render :json => {'errors' => ['Record not found']}, :status => :not_found
    end

    def set_current_user
      @current_user ||= AccountBlock::Account.find_by(id: @token.id)
      return render json: {errors: 'Invalid Token'}, :status => :not_found if @current_user.blank?
    end

    def validate_card_details(number,month,year,cvc)
      return "Card number is Invalid" unless number.to_s.length == 16
      return "Enter a valid month" unless (month.to_i>0 && month.to_i <=12)
      return "Enter a valid year" unless  year.to_i >= Time.now.year
      return "CVV no is invalid" unless cvc.to_s.length == 3
    end
  end
end