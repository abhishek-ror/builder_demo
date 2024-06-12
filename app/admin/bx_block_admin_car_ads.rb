ActiveAdmin.register BxBlockAdmin::CarAd, as: "Car Ads" do

  permit_params :city_id, :make_year, :mileage, :mobile_number, :kms, :more_details, :body_type,:regional_spec, :steering_side, :body_color,:no_of_doors, :no_of_cylinder, :horse_power, :warranty, :battery_capacity, :transmission, :price, :status, :fuel_type, :account_id, :admin_user_id, :trim_id, :order_id, :fuel_type_description, :otp, :ad_type, :car_type, extra_ids: [],feature_ids: [], badge_ids: [], regional_spec_ids: [], color_ids: [], seller_type_ids: [], car_engine_type_ids: [] ,images_attributes: [:id, :image, :_destroy]

  VALIDATION_FILEDS = 'this.value = this.value.replace(/[^0-9+]/g, "");'

  show do 
    attributes_table do

      row :city do |record|
        record&.city&.name
      end
      row :make_year do |record|
        record&.make_year
      end
      row :mileage do |record|
        record&.mileage
      end
      row :fuel_type do |record|
        record&.fuel_type
      end
      row :regional_spec do |record|
        record&.regional_specs&.first
      end
      row :more_details do |record|
        record&.more_details
      end
      row :no_of_doors do |record|
        record&.no_of_doors
      end
      row :steering_side do |record|
        record&.steering_side
      end
      row :transmission do |record|
        record&.transmission
      end
      row :price do |record|
        record&.price&.to_s(:delimited)
      end
      row :status do |record|
        record&.status
      end
      row :account do |record|
        link_to("#{record&.account&.full_name}","/admin/accounts/#{record&.account&.id}") 
      end
      row :admin_user do |record|
        record&.admin_user&.email
      end
      row :trim do |record|
        record&.trim&.name
      end
      row :order do |record|
        record&.order_id
      end
      row :otp do |record|
        record&.otp
      end
      row :ad_type do |record|
        record&.ad_type
      end
      row :kms do |record|
        record&.kms
      end
      row :mobile_number do |record|
        record&.mobile_number
      end
      row :car_type do |record|
        record&.car_type
      end
      row :horse_power do |record|
        record&.horse_power
      end
      row :no_of_cylinder do |record|
        record&.no_of_cylinder
      end
      row :battery_capacity do |record|
        record&.battery_capacity
      end
      row :warranty do |record|
        record&.warranty
      end
      row :body_type do |record|
        record&.body_type
      end
      row :body_color do |record|
        record.colors&.last&.name&.humanize
      end
      row :regional_spec do |record| 
        record&.regional_specs&.first
      end
      row :model do |record|
        record.model
      end
      row :make do |record|
        record.model.company
      end
    end
  end

  index do 
    selectable_column
    column :id
    column :city
    column :account
    column :trim
    column :price do |record|
      record&.price&.to_s(:delimited)
    end
    columns_to_exclude = ["ad_type", "car_type", "admin_user_id", "account_id", "regional_spec", "trim_id", "user_subscription_id", "city_id", "id", "body_color", "price"]
    (BxBlockAdmin::CarAd.column_names - columns_to_exclude).each do |c|
      column c.to_sym
    end
    column :ad_type do |record|
      record.ad_type&.humanize
    end
    column :car_type do |record|
      record.car_type&.humanize
    end
    column :body_color do |record|
      record.colors&.last&.name&.humanize
    end 
    actions
  end

  filter :make_year, as: :select, collection: BxBlockAdmin::CarAd.pluck(:make_year).uniq
  filter :city
  filter :trim
  filter :account
  filter :features
  filter :extras
  filter :badges
  filter :regional_specs
  filter :car_engine_types
  filter :seller_types
  #filter :user_subscription
  filter :no_of_doors 
  filter :no_of_cylinder 
  filter :price
  filter :kms
  filter :battery_capacity
  filter :horse_power 
  # filter :warranty, as: :select, collection: BxBlockAdmin::CarAd.warranties
  # filter :body_type, as: :select, collection: BxBlockAdmin::CarAd.pluck(:body_type).uniq
  filter :steering_side, as: :select, collection: BxBlockAdmin::CarAd::STEERING_SIDES_VALUES.map.each_with_index{|a, index| [a, index + 1]}
  # filter :body_color, as: :select, collection: BxBlockAdmin::CarAd.pluck(:body_color).uniq
  filter :car_type, as: :select, collection: [['New', 1], ['Used', 2]]
  filter :ad_type, as: :select, collection: [['General', 0], ['Top deals', 1], ['Featured', 2]]
  filter :status, as: :select, collection: [['Drafted', 0], ['Posted', 1], ['Sold', 2], ['Deleted', 3]]

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs except: [:otp, 'admin_user', :regional_spec, 'user_subscription', :body_color, :make_year, :mileage, :no_of_doors, :no_of_cylinder, :horse_power, :price, :battery_capacity, :kms, :mobile_number]

    f.input :make_year, as: :string, input_html: { oninput: VALIDATION_FILEDS, maxlength: 4 }
    f.input :mileage, as: :string, input_html: { oninput: VALIDATION_FILEDS, maxlength: 4 }
    f.input :no_of_doors, as: :string, input_html: { oninput: VALIDATION_FILEDS, maxlength: 4 }
    f.input :no_of_cylinder, as: :string, input_html: { oninput: VALIDATION_FILEDS, maxlength: 4 }
    f.input :horse_power, as: :string, input_html: { oninput: VALIDATION_FILEDS, maxlength: 4 }
    f.input :price, as: :string, input_html: { oninput: VALIDATION_FILEDS }
    f.input :battery_capacity, as: :string, input_html: { oninput: VALIDATION_FILEDS }
    f.input :kms, as: :string, input_html: { oninput: VALIDATION_FILEDS, maxlength: 4 }
    f.input :mobile_number, as: :string, input_html: { oninput: VALIDATION_FILEDS, maxlength: 20 }    

    f.input :body_color, as: :select, collection: BxBlockAdmin::Color.all.map{ |a| [a.name,a.id]}

    f.input :admin_user, as: :select, collection: AdminUser.all.map{ |a| [a.email,a.id]}
    
    f.inputs "Images" do
      f.has_many :images, heading: false, allow_destroy: true do |cd|
        hint = image_tag(cd.object.image.url, style: "height: 10%; width: 10%") if cd.object.image.url
        cd.input :image, as: :file, :hint => hint
      end
    end
    
    f.inputs "Features" do
      f.input :features, as: :select, collection: [["Select a feature", nil]] + BxBlockAdmin::Feature.all.map { |feature| [feature.name, feature.id] }, input_html: { multiple: false }
    end

    f.inputs "Extras" do
      f.input :extras, as: :select, collection: [["Select an extra", nil]] + BxBlockAdmin::Extra.all.map { |extra| [extra.name, extra.id] }, input_html: { multiple: false }
    end

    f.inputs "Badges" do
      f.input :badges, as: :select, collection: [["Select a badge", nil]] + BxBlockAdmin::Badge.all.map { |badge| [badge.name, badge.id] }, input_html: { multiple: false }
    end

    f.inputs "Regional Specs" do
      f.input :regional_specs, as: :select, collection: [["Select a regional spec", nil]] + BxBlockAdmin::RegionalSpec.all.map { |regional_spec| [regional_spec.name, regional_spec.id] }, input_html: { multiple: false }
    end

    f.inputs "Colors" do
      f.input :colors, as: :select, collection: [["Select a color", nil]] + BxBlockAdmin::Color.all.map { |color| [color.name, color.id] }, input_html: { multiple: false }
    end

    f.inputs "Engine Types" do
      f.input :car_engine_types, as: :select, collection: [["Select an engine type", nil]] + BxBlockAdmin::CarEngineType.all.map { |engine_type| [engine_type.name, engine_type.id] }, input_html: { multiple: false }
    end

    f.inputs "Seller Types" do
      f.input :seller_types, as: :select, collection: [["Select a seller type", nil]] + BxBlockAdmin::SellerType.all.map { |seller_type| [seller_type.name, seller_type.id] }, input_html: { multiple: false }
    end

    f.actions
  end

  batch_action :add_to_top_deals do |ids|
    batch_action_collection.find(ids).each do |car_ad|
      car_ad.top_deals!
    end
    redirect_to admin_car_ads_path, alert: "CarAds added to the Top Deals"
  end

  batch_action :add_to_featured_ads do |ids|
    batch_action_collection.find(ids).each do |car_ad|
      car_ad.featured!
    end
    redirect_to admin_car_ads_path, alert: "CarAds added to the Featured"
  end

  batch_action :add_to_general_ads do |ids|
    batch_action_collection.find(ids).each do |car_ad|
      car_ad.general!
    end
    redirect_to admin_car_ads_path, alert: "CarAds added to the General"
  end
end
