module BxBlockOrdercreation3s
  class CarOrderSerializer
    include JSONAPI::Serializer
    attributes *[
     :order_request_id,
     :continent,
     :country,
     :state,
     :area,
     :country_code,
     :phone_number,
     :full_phone_number,
     :status,
     :status_updated_at,
     :notes,
     :created_at
    ]
    attributes :final_invoice do |object|
      object.final_invoice.attached? ? object.final_invoice.service_url : nil
    end
    attributes :payment_receipt do |object|
      # object.payment_receipt.attached? ? Rails.application.routes.url_helpers.rails_blob_path(object.photo, only_path: true) : "image not present"
      object.payment_receipt.attached? ? object.payment_receipt.service_url : nil
    end
    attributes :passport do |object|
      object.passport.attached? ? object.passport.service_url : nil
    end

    attributes :other_documents do |object|
      # get_other_documents object
      if object&.other_documents&.attached?
        object&.other_documents.map{|doc| doc.service_url}
      end
    end
    attributes :car_details do |object|
      # get_order_details object
      if object&.car_ad.present?
        BxBlockPosts::CarAdSerializer.new(object&.car_ad).serializable_hash[:data][:attributes]
      end
    end

    attributes :shipment_details do |object|
      # get_shipment_details object
      if object&.shipment.present?
        BxBlockShipments::ShipmentSerializer.new(object&.shipment, {params: {hide_order_dtl: true}}).serializable_hash[:data][:attributes]
      end
    end

    attributes :account do |object|
      # get_account_details object
      AccountBlock::AccountSerializer.new(object.account).serializable_hash[:data][:attributes]
    end






    # class << self
    #   private


    #   def get_shipment_details object
    #     shipment = BxBlockShipment::Shipment.find_by(account_id: object.account_id,car_orders_id: object.id)
    #   end

    #   def get_account_details object
    #     account_details = []
    #     get_account = AccountBlock::Account.find_by(id: object.account_id)
    #     if get_account
    #       account_details << AccountBlock::EmailAccountSerializer.new(get_account)
    #     end
    #   end

    #   def get_order_details object
    #     order = BxBlockAdmin::CarAd.find(object.car_ad_id)
    #     order_details = BxBlockPosts::CarAdSerializer.new(order) if order.present?
    #   end



    #   def get_other_documents object
    #     documents = []
    #     docs = BxBlockOrdercreation3::CarOrder.find_by(order_request_id: object.order_request_id,account_id: object.account_id)
    #     if docs.c.present?
    #       docs.other_documents.each do |doc|
    #         documents << doc.service_url
    #       end
    #     end
    #     documents
    #   end

    # end
  end

end
