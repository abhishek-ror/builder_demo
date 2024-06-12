ActiveAdmin.register BxBlockVehicleShipping::VehicleSelling, as: "Vehicle Selling" do

    actions :all, :except => [:new]

    permit_params :city_id, :account_id, :trim_id, :region_id, 
    :country_id, :state_id, 
    :year, :model, :regional_spec, :kms, :body_type, :body_color,
    :seller_type, :engine_type, :steering_side, :badges, :approved_by_admin, 
    :features, :make, :no_of_doors, :transmission, :price, :warranty, :no_of_cylinder,
    :horse_power, :contact_number, :about_car, :tracking_status, images_attributes: [:id, :image, :item_type]

    member_action :approve, method: :put do
      resource.update(approved_by_admin: "true")
      redirect_to admin_vehicle_sellings_path, notice: "Vehicle Selling approved updated successfully."
    end

    controller do
      def scoped_collection
        BxBlockVehicleShipping::VehicleSelling.where(verified: true)
      end
    end

    index do 
      selectable_column
        id_column
        column :account do |record|
          link_to("#{record&.account&.full_name}","/admin/accounts/#{record&.account&.id}") 
        end
        column :country do |record|
          record&.country&.name
        end
        column :city do |record|
          record&.city&.name
        end
        column :state do |record|
          record&.state&.name
        end
        column :trim do |record|
          record&.trim&.name
        end
        column :region do |record|
          record&.region&.name
        end
        columns_to_exclude = ["account_id", "price", "id", "trim_id", "city_id", "state_id", "region_id", "country_id", "is_inspected"]
        (BxBlockVehicleShipping::VehicleSelling.column_names - columns_to_exclude).each do |c|
          column c.to_sym
        end
        column :price 
      actions defaults: true do |vehicle_selling|
        if vehicle_selling.approved_by_admin == false
          link_to "Approve", approve_admin_vehicle_selling_path(vehicle_selling), method: :put 
        end
      end
    end

    show do 
      attributes_table do
        row :account do |record|
          link_to("#{record&.account&.full_name}","/admin/accounts/#{record&.account&.id}") 
        end
        row :city do |record|
          record&.city&.name
        end
        row :state do |record|
          record&.state&.name
        end
        row :trim do |record|
          record&.trim&.name
        end
        row :region do |record|
          record&.region&.name
        end
        row :country do |record|
          record&.country&.name
        end
        row :regional_spec do |record|
          record&.regional_spec
        end
        row :year do |record|
          record&.year
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
        row :price
        row :tracking_status 
        row :kms do |record|
          record&.kms
        end
        row :contact_number do |record|
          record&.contact_number
        end
        row :horse_power do |record|
          record&.horse_power
        end
        row :no_of_cylinder do |record|
          record&.no_of_cylinder
        end
        row :warranty do |record|
          record&.warranty
        end
        row :body_type do |record|
          record&.body_type
        end
        row :body_color do |record|
          record&.body_color
        end
        row :model do |record|
          record&.model
        end
        row :make do |record|
          record&.make
        end
        row :features do |record|
          record&.features
        end
        row :badges do |record|
          record&.badges
        end
        row :seller_type do |record|
          record&.seller_type
        end
        row :engine_type do |record|
          record&.engine_type
        end
        row :about_car do |record|
          record&.about_car
        end
        row :approved_by_admin do |record|
          record&.approved_by_admin
        end
      end
    end

    form do |f|
      f.inputs do
        f.input :region_id, :label => 'Region', as: :select, collection: BxBlockAdmin::Region.all.map{|r| [r.name, r.id]}
        f.input :country_id, :label => 'Country', as: :select, collection: BxBlockAdmin::Country.all.map{|c| [c.name, c.id]}
        f.input :state_id, :label => 'State', as: :select, collection: BxBlockAdmin::State.all.map{|s| [s.name, s.id]}
        f.input :city_id, :label => 'City', as: :select, collection: BxBlockAdmin::City.all.map{|c| [c.name, c.id]}
        f.input :trim_id, :label => 'Trim', as: :select, collection: BxBlockAdmin::Trim.all.map{|t| [t.name, t.id]}
        f.input :model
        f.input :year
        f.input :contact_number, as: :string, input_html: { oninput: 'this.value = this.value.replace(/[^0-9]/g, "");', maxlength: 20 }
        f.input :kms
        f.input :body_type
        f.input :body_color, as: :string
        f.input :seller_type
        f.input :engine_type
        f.input :steering_side
        f.input :badges
        f.input :features
        f.input :make
        f.input :transmission
        f.input :price
        f.input :warranty
        f.input :no_of_cylinder
        f.input :no_of_doors
        f.input :horse_power
        f.input :regional_spec
        f.input :tracking_status
        f.input :approved_by_admin
        f.input :about_car
      end
      f.actions
    end
end
  