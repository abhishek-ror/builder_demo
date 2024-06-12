module AccountBlock
  class Account < AccountBlock::ApplicationRecord
    self.table_name = :accounts


    include Wisper::Publisher
    has_secure_password
    # validates :email, uniqueness: true
    validates :full_phone_number, uniqueness: true
    # before_validation :parse_full_phone_number
    before_validation :valid_phone_number
    before_create :generate_api_key
    has_one :blacklist_user, class_name: 'AccountBlock::BlackListUser', dependent: :destroy
    has_one :profile, class_name: 'BxBlockProfile::Profile', dependent: :destroy
    has_one :address, class_name: 'BxBlockAddress::Address', dependent: :destroy
    has_many :car_ads, class_name: 'BxBlockAdmin::CarAd', dependent: :destroy
    has_many :push_notification, class_name: 'BxBlockPushNotifications::PushNotification', dependent: :destroy
    has_many :favourites, class_name: "BxBlockFavourites::Favourite", dependent: :destroy, foreign_key: :favourite_by_id
    has_many :favourite_car_ads, through: :favourites, source: :favouriteable, source_type: "BxBlockAdmin::CarAd", dependent: :destroy
    has_many :favourite_vehicle_sellings, through: :favourites, source: :favouriteable, source_type: "BxBlockVehicleShipping::VehicleSelling", dependent: :destroy
    has_many :car_orders, class_name: 'BxBlockOrdercreation3::CarOrder', dependent: :destroy
    has_many :vehicle_orders, class_name: 'BxBlockVehicleShipping::VehicleOrder', dependent: :destroy
    has_many :shipments, class_name: 'BxBlockShipment::Shipment', dependent: :destroy,foreign_key: :account_id
    has_many :vehicle_shippings, class_name: 'BxBlockVehicleShipping::VehicleShipping', dependent: :destroy, foreign_key: :account_id
    has_many :vehicle_sellings, class_name: 'BxBlockVehicleShipping::VehicleSelling', dependent: :destroy, foreign_key: :account_id
    after_save :set_black_listed_user
    has_many :vehicle_payments, class_name: 'VehiclePayment'
    has_many_attached :docs
    # validates :docs, content_type: {
    #   in: ['application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'application/pdf', 'image/jpeg', 'image/png'],
    #   message: 'docs should be a DOC, PDF, JPEG, or PNG file',
    #   if: -> { docs.attached? }
    # }, unless: -> { docs.blank? }
    has_many :user_subscriptions, class_name: "BxBlockPlan::UserSubscription", dependent: :destroy
    accepts_nested_attributes_for :user_subscriptions, allow_destroy: true
    # has_many :plans, through: :subscription_plans
    has_many :vehicle_inspections, class_name: 'BxBlockAdmin::VehicleInspection', dependent: :destroy
    has_many :credit_cards, class_name: 'BxBlockPayments::CreditCard', dependent: :destroy
    has_many :vehicle_selling_inspections, class_name: 'BxBlockAdmin::VehicleSellingInspection', dependent: :destroy
    after_create :create_free_user_subscription
    has_many :payment_transactions, class_name: 'BxBlockPayments::PaymentTransaction', dependent: :destroy
    has_many :inspector_inspections, class_name: 'BxBlockAdmin::VehicleInspection', dependent: :destroy, foreign_key: :inspector_id
    has_many :vehicle_selling_inspections, class_name: 'BxBlockAdmin::VehicleSellingInspection', dependent: :destroy, foreign_key: :inspector_id
    # after_save :create_profile_and_address

    enum status: %i[regular suspended deleted]

    scope :active, -> { where(activated: true) }
    scope :existing_accounts, -> { where(status: ['regular', 'suspended']) }
    # before_validation :create_on_stripe, on: :create
    # validates :stripe_id, presence: true, on: :create

    def latest_subscription_plan
      user_subscriptions.activated.last
    end

    def requested_subscription_plan
      user_subscriptions.pending.last
    end

    private

    def create_on_stripe
      params = { email: "email", name: full_name || company_name }
      response = Stripe::Customer.create(params)
      self.stripe_id = response.id
    end

    def create_profile_and_address
      profile = BxBlockProfile::Profile.new(account_id: @account.id)
      profile.save
      address = BxBlockAddress::Address.new(account_id: @account.id)
      address.save
    end

    def parse_full_phone_number
      phone = Phonelib.parse(full_phone_number)
      self.full_phone_number = phone.sanitized
      self.country_code      = phone.country_code
      self.phone_number      = phone.raw_national
    end

    def valid_phone_number
      unless Phonelib.valid?(full_phone_number)
        errors.add(:full_phone_number, "Please enter valid phone number")
      end
    end

    def generate_api_key
      loop do
        @token = SecureRandom.base64.tr('+/=', 'Qrt')
        break @token unless Account.exists?(unique_auth_id: @token)
      end
      self.unique_auth_id = @token
    end

    def set_black_listed_user
      if is_blacklisted_previously_changed?
        if is_blacklisted
          AccountBlock::BlackListUser.create(account_id: id)
        else
          blacklist_user.destroy
        end
      end
    end

    def create_free_user_subscription
      free_plan = BxBlockPlan::Plan.find_or_create_by(name: "Free Plan")
      user_subscriptions.find_or_create_by(plan_id: free_plan.id, status: 1)
    end
  end
end