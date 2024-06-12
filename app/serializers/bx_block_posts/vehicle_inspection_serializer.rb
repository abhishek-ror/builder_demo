class BxBlockPosts::VehicleInspectionSerializer < BuilderBase::BaseSerializer
  attributes :model_id, :city_id, :make_year, :about, :price, :seller_country_code,:seller_mobile_number, :seller_email, :seller_name, :inspection_amount, :notes_for_the_inspector, :status, :inspection_report, :advertisement_url, :car_ad_type, :inspection_scheduled_on, :acceptance_status, :instant_deposit_receipt, :document, :payment_receipt, :notes_for_the_admin, :instant_deposit_status, :instant_deposit_link, :status_updated_at, :final_sale_amount
  attribute :city do |object|
    object.city.as_json
  end


  attribute :regional_spec do |object|
    if object.vin_number.present?
       BxBlockAdmin::RegionalSpec.where(name: object.vin_number).select(:id, :name).as_json
    elsif object.car_ad_type == "vehicle_selling" || object.car_ad_type == "vehicle selling"
      r_s = BxBlockVehicleShipping::VehicleSelling.find_by(id: object.car_ad_id).regional_spec
      BxBlockAdmin::RegionalSpec.where(name: r_s).present? ? BxBlockAdmin::RegionalSpec.where(name: r_s).select(:id, :name).as_json : ""
    elsif object.car_ad_id.present?
      if BxBlockAdmin::CarAd.find_by(id: object.car_ad_id).present?
        BxBlockAdmin::CarAd.find_by(id: object.car_ad_id).regional_specs&.last&.as_json(only: [:id, :name])
      end
    else
      ""
    end
  end
  
  attribute :order_details do |object|
    {
      "order_number": object.vehicle_order ? object.vehicle_order.order_request_id : object.id,
      "order_request_id": object.vehicle_order ? object.vehicle_order.order_request_id : object.id,
      "date_of_order": object.created_at.strftime('%d-%b-%Y') 
    }
  end

  attribute :model do |object|
    if object.model.present?
      object&.model.as_json(only: [:id, :name])
    elsif object.car_ad_type == "vehicle_selling" || object.car_ad_type == "vehicle selling"
      BxBlockVehicleShipping::VehicleSelling.find_by(id: object.car_ad_id).model.as_json(only: [:id, :name])
    elsif object.car_ad_id.present?
      BxBlockAdmin::CarAd.find_by(id: object.car_ad_id).trim.model.as_json(only: [:id, :name])
    else
      ""
    end
  end

  attribute :make do |object|
    if object.company.present?
      object&.company&.as_json(only: [:id, :name])
    elsif object.car_ad_type == "vehicle_selling" || object.car_ad_type == "vehicle selling"
      BxBlockVehicleShipping::VehicleSelling.find_by(id: object.car_ad_id).trim.model.company.as_json(only: [:id, :name])
    elsif object.car_ad_id.present?
      BxBlockAdmin::CarAd.find_by(id: object.car_ad_id).trim.model.company.as_json(only: [:id, :name])
    else
      ""
    end
  end

  attribute :images do |object|
    if object.images.present?
      object&.images.as_json(only: [:id, :image])
    elsif object.car_ad_id.present? 
      if object.car_ad_type == "vehicle_selling" || object.car_ad_type == "vehicle selling"
        BxBlockVehicleShipping::VehicleSelling.find_by(id: object.car_ad_id).images.as_json(only: [:id, :image])
      else
        BxBlockAdmin::CarAd.find_by(id: object.car_ad_id).images.as_json(only: [:id, :image])
      end 
    end
  end

  attribute :inspection_report do |object|
    if object.inspection_report.present?
      BxBlockPosts::VehicleInspectionReportSerializer.new(object.inspection_report).serializable_hash[:data]
    end  
  end

  attribute :order_date do |object|
    if object.status == "rejected" || object.status == "accepted_for_inspection" || object.status == "completed" || object.status == "inprogress"
      object.updated_at
    else
      ""
    end
  end
  attribute :car_ad do |object|
    object.car_ad_id.present? ? true : false
  end
  attribute :car_order do |object|
    object&.vehicle_order.as_json(only: [:id, :order_request_id, :final_invoice_payment_status, :status])
  end

  attribute :car_data do |object|
    if object.car_ad_id.present?
      if object.car_ad_type == "vehicle_selling" || object.car_ad_type == "vehicle selling"
        car_ad = BxBlockVehicleShipping::VehicleSelling.find_by(id: object.car_ad_id)
        BxBlockVehicleShippings::VehicleSellingSerializer.new(car_ad).serializable_hash[:data][:attributes]
      else
        car_ad = BxBlockAdmin::CarAd.find_by(id: object.car_ad_id)
        BxBlockVehicleShippings::NewCarAdSerializer.new(car_ad).serializable_hash[:data][:attributes]
      end
    else
      []
    end
  end

    attributes :final_invoice do |object|
      if Rails.env.development? || Rails.env.test?
        Rails.application.routes.url_helpers.rails_blob_path(object.final_invoice, only_path: true) if object.final_invoice.attached?
      else
        object.final_invoice.attached? ? object.final_invoice.service_url : nil
      end
    end

    attributes :time_left do |object|
      if object.status_updated_at
        a = ((Time.parse(DateTime.now.to_s) - Time.parse(object.status_updated_at.to_s))/1.minute).divmod(60).map{|x| x.to_i}
        hours = (a[1] > 0) ? "#{24 -(1 + a[0])}:#{60 - a[1]}" :  "#{24 -a[1]}:00"
      else
        ""
      end
    end

end