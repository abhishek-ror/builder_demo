class BxBlockAdmin::CarAd < ApplicationRecord
  self.table_name = :car_ads
  belongs_to :city
  belongs_to :trim
  belongs_to :account, class_name: 'AccountBlock::Account', optional: true, foreign_key: :account_id
  belongs_to :admin_user, class_name: 'AdminUser',optional: true
  belongs_to :user_subscription, class_name: 'BxBlockPlan::UserSubscription',optional: true

  has_many :car_orders, class_name: 'BxBlockOrdercreation3::CarOrder', foreign_key: :car_ad_id
  has_many :vehicle_orders, class_name: 'BxBlockVehicleShipping::VehicleOrder', dependent: :destroy
  has_many :images, as: :attached_item, class_name: 'BxBlockContentManagement::Image'
  has_many :favourites, as: :favouriteable, class_name: 'BxBlockFavourites::Favourite'
  has_one :vehicle_inspection, as: :inspectionable, class_name: 'BxBlockAdmin::VehicleInspection', dependent: :destroy

  has_one :vehicle_inspection, class_name: 'BxBlockAdmin::VehicleInspection'
  has_many :vehicle_payments, class_name: 'VehiclePayment', dependent: :destroy

  
  has_and_belongs_to_many :features
  has_and_belongs_to_many :extras
  has_and_belongs_to_many :badges
  has_and_belongs_to_many :regional_specs
  has_and_belongs_to_many :colors
  has_and_belongs_to_many :car_engine_types
  has_and_belongs_to_many :seller_types

  validates :mileage, :battery_capacity, :kms, :no_of_cylinder, :no_of_doors, :horse_power, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :price, numericality: { only_numeric: true, greater_than: 0, message: 'must be greater than 0' }, allow_blank: true

  validates :account_id, presence: true
  validates :make_year, numericality: { only_integer: true, greater_than: 0 }
  validates :make_year, length: { minimum: 4, maximum: 4 }, allow_blank: true
  delegate :model, :to => :trim
  before_create :generate_order_id
  validate :create_only_three, on: :create
  accepts_nested_attributes_for :images, allow_destroy: true

  REGIONAL_SPEC = ["European", "GCC", "Japanese", "NorthAmerical", "Other"]
  STEERING_SIDES = {"left": 1, "right": 2}.freeze
  TRANSMISSIONS = { "manual": 0, "cvt": 1, "dct": 2, "imt": 2}.freeze
  STATUSES = {"drafted": 0, "posted": 1, "sold": 2, "deleted": 3}
  FUEL_TYPE = {"Petrol": 0, "Diesel": 1,"Electric": 2}
  AD_TYPES = {"general": 0, "top_deals": 1, "featured": 2}
  ADS_POSTED = ['Any Time', 'Today', 'Within 3 days', 'Within 1 week', 'Within 2 weeks', 'Within 1 month', 'Within 3 month', 'Within 6 month']
  OTHER_FILTERS = ['Show ads with photos only', 'Show ads with 360 tour only', 'Show ads with Car History Report', 'Show ads in English only', 'Show ads with verified tick']
  STEERING_SIDES_VALUES = ['Left hand side', 'Right hand side']
  WARRANTY = ['Yes', 'No', 'Does not apply']
  SELLER_TYPE = ['Owner', 'Dealer', 'Dealership/Certified Pre-Owned']
  MODEL_YEAR = (1945..Date.today.year).to_a
  CAR_TYPE = ['New', 'Used']
  DOORS = [{'id': 2, name: '2 door'}, {'id': 3, name: '3 door'}, {'id': 4, name: '4 door'}, {'id': 5, name: '5+ door'}, {'id': 6, name: 'Other'}]
  HORSE_POWER = [{id: 1, start: 0, end: 150, name: 'Less than 150 HP'}, {id: 2, start: 150, end: 200, name: '150 - 200 HP'}, {id: 3, start: 200, end: 300, name: '200 - 300 HP'}, {id: 4, start: 300, end: 400, name: '300 - 400 HP'}, {id: 5, start: 400, end: 500, name: '400 - 500 HP'}, {id: 6, start: 500, end: 600, name: '500 - 600 HP'}, {id: 7, start: 600, end: 700, name: '600 - 700 HP'}, {id: 8, start: 700, end: 800, name: '700 - 800 HP'}, {id: 9, start: 800, end: 900, name: '800 - 900 HP'}, {id: 10, start: 900, end: 15000, name: '900+ HP'}]
  CYLINDERS = [3,4,5,6,8,10,12,13].map{|num|{id: num, name: num != 13 ? num.to_s : 'None'}}
  PRICEFILTER = []
  PRICE = [1000,5000,10000,50000,100000,500000,1000000,500000,10000000]
  # default_scope { order(created_at: :desc) }
  # default_scope lambda { where.not(status: 3) }
  
  enum status: STATUSES
  enum transmission: TRANSMISSIONS
  enum steering_side: STEERING_SIDES
  enum ad_type: AD_TYPES
  enum fuel_type: FUEL_TYPE
  enum car_type: {new_car: 1, used_car: 2}
  enum warranty: {"Yes"=>1, "No"=>2, "Does not apply"=>3}

  def generate_order_id
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
    self.order_id = (0...8).map{ charset.to_a[rand(charset.size)] }.join
    self.otp = rand.to_s[2..5] 
  end


  def send_email_otp(url)
    BxBlockPosts::CarAdMailer
      .with(otp: otp, email: account.email,  host: url)
      .send_otp.deliver
  end

  def create_only_three
    errors.add(:base, "The limit for all posts in your current plan has been utilized. Please upgrade now to avail ad posting services.") if self.account.present? && self.account.car_ads.posted.count >= self.account.latest_subscription_plan&.plan&.ad_count.to_i
  end

  def self.query_data
    {

      kms: BxBlockAdmin::CarAd.pluck(:kms).map(&:to_i).uniq.compact.sort,
      make: BxBlockAdmin::Company.pluck(:name).uniq,
      body_type: (BxBlockAdmin::Model.pluck(:body_type).uniq + BxBlockAdmin::CarAd.pluck(:body_type)).flatten.compact.uniq.reject  { |c| c.empty? },
      # engine_type: BxBlockAdmin::Model.pluck(:engine_type).uniq,
      no_of_doors: BxBlockAdmin::CarAd.pluck(:no_of_doors).uniq.compact,
      cylinders: BxBlockAdmin::CarAd.pluck(:no_of_cylinder).uniq.compact,
      model_names: BxBlockAdmin::Model.pluck(:name).uniq,
      transmissions: BxBlockAdmin::CarAd::TRANSMISSIONS,
      regional_specs: BxBlockAdmin::RegionalSpec.select(:id, :name).as_json,
      # steering_side: BxBlockAdmin::CarAd::STEERING_SIDES,
      steering_side: BxBlockAdmin::CarAd::STEERING_SIDES_VALUES.map.each_with_index{|a, index| {id: index + 1, name: a}},
      body_colors: BxBlockAdmin::Color.select(:id, :name).as_json,
      seller_type: BxBlockAdmin::SellerType.select(:id, :name).as_json,
      warranty: BxBlockAdmin::CarAd::WARRANTY,
      badges: BxBlockAdmin::Badge.select(:id, :name).as_json,
      features: BxBlockAdmin::Feature.select(:id, :name).as_json,
      extras: BxBlockAdmin::Extra.select(:id, :name).as_json,
      years: BxBlockAdmin::CarAd::MODEL_YEAR,
      engine_type: BxBlockAdmin::CarEngineType.select(:id, :name, :engine_type).as_json,
      car_type: BxBlockAdmin::CarAd::CAR_TYPE.map.each_with_index{|a, index| {id: index + 1, name: a}},
      price: BxBlockAdmin::CarAd.pluck(:price)&.compact&.uniq&.sort(),
      trim: BxBlockAdmin::Trim.select(:id, :name).as_json,
      dealer_name: AccountBlock::Account.select(:id, :full_name).as_json,
      horse_power: BxBlockAdmin::CarAd.pluck(:horse_power).uniq.compact

    }

  end

  def is_favourite?(current_user_id)
    self.favourites.find_by(favourite_by_id: current_user_id).present?
  end

  def get_favourite_id(current_user_id)
    is_favourite?(current_user_id) ? self.favourites.find_by(favourite_by_id: current_user_id)&.id : nil
  end

end
