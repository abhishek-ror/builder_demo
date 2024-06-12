module BxBlockVehicleShipping
	class VehicleSelling < ApplicationRecord
	    self.table_name = :vehicle_sellings
        
        before_create :generate_tracking_number

        belongs_to :city, class_name: 'BxBlockAdmin::City', optional: true
        belongs_to :account, class_name: 'AccountBlock::Account', optional: true, foreign_key: :account_id
        belongs_to :region, class_name: 'BxBlockAdmin::Region', optional: true
        belongs_to :country, class_name: 'BxBlockAdmin::Country', optional: true
        belongs_to :state, class_name: 'BxBlockAdmin::State', optional: true
        belongs_to :trim, class_name: 'BxBlockAdmin::Trim', optional: true
        belongs_to :admin_user, class_name: 'AdminUser',optional: true
        has_many :favourites, as: :favouriteable, class_name: 'BxBlockFavourites::Favourite', dependent: :destroy
        # has_one :vehicle_inspection, as: :inspectionable, class_name: 'BxBlockAdmin::VehicleInspection', dependent: :destroy
        has_many :images, as: :attached_item, class_name: 'BxBlockContentManagement::Image'
        has_many :vehicle_orders, class_name: 'BxBlockVehicleShipping::VehicleOrder', dependent: :destroy
        has_one :vehicle_selling_inspection, class_name: 'BxBlockAdmin::VehicleSellingInspection'
        has_many :vehicle_payments, class_name: 'VehiclePayment', dependent: :destroy
        REGIONAL_SPEC = ["European", "GCC", "Japanese", "NorthAmerical", "Other"]
        WARRANTY = ['Yes', 'No', 'Does not apply']
        SELLER_TYPE = ['Owner', 'Dealer', 'Dealership/Certified Pre-Owned']
        NO_OF_CYLINDER = [3,4,5,6,8,10,12,13].map{|num|{id: num, name: num != 13 ? num.to_s : 'None'}}
        MODEL = (1990..Date.today.year).to_a
        HORSE_POWER = [{id: 1, start: 0, end: 150, name: 'Less than 150 HP'}, {id: 2, start: 150, end: 200, name: '150 - 200 HP'}, {id: 3, start: 200, end: 300, name: '200 - 300 HP'}, {id: 4, start: 300, end: 400, name: '300 - 400 HP'}, {id: 5, start: 400, end: 500, name: '400 - 500 HP'}, {id: 6, start: 500, end: 600, name: '500 - 600 HP'}, {id: 7, start: 600, end: 700, name: '600 - 700 HP'}, {id: 8, start: 700, end: 800, name: '700 - 800 HP'}, {id: 9, start: 800, end: 900, name: '800 - 900 HP'}, {id: 10, start: 900, end: 15000, name: '900+ HP'}]
        #ENGINE_TYPE = ['Petrol', 'Diesel', 'Electric']
        NO_OF_DOORS = [{'id': 2, name: '2 door'}, {'id': 3, name: '3 door'}, {'id': 4, name: '4 door'}, {'id': 5, name: '5+ door'}, {'id': 6, name: 'Other'}]

        enum warranty: {"Yes"=>1, "No"=>2, "Does not apply"=>3}
        enum tracking_status: {"Under approval"=>0, "Posted"=>1, "Sold"=>2}
        validates :year, numericality: { only_integer: true, greater_than: 0 }
        validates :year, length: { minimum: 4, maximum: 4 }, allow_blank: true
        
        validates :kms, :no_of_cylinder, :no_of_doors, :horse_power, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true

        validates :price, numericality: { only_numeric: true, greater_than: 0, message: 'must be greater than 0' }, allow_blank: true

        def is_favourite?(current_user_id)
            self.favourites.find_by(favourite_by_id: current_user_id).present?
        end

        def get_favourite_id(current_user_id)
            is_favourite?(current_user_id) ? self.favourites.find_by(favourite_by_id: current_user_id)&.id : nil
        end

        def generate_tracking_number
          charset = %w{ 1 2 3 4 5 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
          loop do
            tracking_id = "OR" + (0...8).map{ charset.to_a[rand(charset.size)] }.join
            next if self.class.find_by(tracking_number: tracking_id).present?
            self.tracking_number = tracking_id
            break
          end
        end
    end
end