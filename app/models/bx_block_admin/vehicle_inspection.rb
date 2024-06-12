class BxBlockAdmin::VehicleInspection < ApplicationRecord
  self.table_name = :vehicle_inspections
  include StripePaymentLink

  ACCOUNT_CLASS_NAME = 'AccountBlock::Account'.freeze
  NOTIFY_TYPE = 'Inspection Report'.freeze

  default_scope { order('id DESC') }
  before_save :set_inspection_scheduled_on, if: :inspector_id_changed?
  belongs_to :city, optional: true
  belongs_to :model, optional: true
  belongs_to :car_ad, class_name: 'BxBlockAdmin::CarAd', optional: true, foreign_key: :car_ad_id
  belongs_to :inspector, class_name: ACCOUNT_CLASS_NAME, optional: true, foreign_key: :inspector_id
  belongs_to :account, class_name: ACCOUNT_CLASS_NAME, optional: true, foreign_key: :account_id
  belongs_to :admin_user, class_name: 'AdminUser',optional: true
  has_one :inspection_report, dependent: :destroy
  has_many :inspection_reports, dependent: :destroy
  belongs_to :inspectionable, polymorphic: true, optional: true
  has_one_attached :payment_receipt
  has_one_attached :document
  has_one_attached :instant_deposit_receipt
  has_many_attached :auto_image
  has_one_attached :inspection_invoice
  has_one_attached :final_invoice
  has_many :images, as: :attached_item, class_name: 'BxBlockContentManagement::Image'
  has_many :other_documents, -> { where(item_type: 'other_documents') }, as: :attached_item, class_name: 'BxBlockContentManagement::Image'
  has_one :car_order, class_name: 'BxBlockOrdercreation3::CarOrder'
  has_one :vehicle_order, class_name: 'BxBlockVehicleShipping::VehicleOrder'
  delegate :company, :to => :model
  after_create :create_car_order
  after_save :update_inspection_status
  before_update :generate_instant_payment_link

  validates :make_year, numericality: { only_integer: true, greater_than: 0 }
  validates :make_year, length: { minimum: 4 }, allow_blank: true
  validates :city_id, presence: true
  validates :account_id, presence: true
  validates :model_id, presence: true
  validates :car_ad_id, uniqueness: { scope: :car_ad_type }, if: -> { car_ad_id.present? && car_ad_type.present? }
  
  # validates :inspector_id, presence: true
  # validates :seller_name, presence: true
  # validates :seller_country_code, presence: true
  # validates :seller_mobile_number, presence: true
  # validates :seller_email, presence: true
  #validates :final_sale_amount, numericality: { only_numeric: true }, allow_blank: true
  # validates :inspection_amount, presence: true

  validates :price, presence: true, numericality: { only_numeric: true, greater_than: 0, message: 'must be greater than 0' }, allow_blank: true
  validates :inspection_amount, numericality: { only_numeric: true,  greater_than: 0, message: 'must be greater than 0' }, allow_blank: true
  validates :instant_deposit_amount, numericality: { only_numeric: true,  greater_than: 0, message: 'must be greater than 0' }, allow_blank: true
  validates :final_sale_amount, numericality: { only_numeric: true,  greater_than: 0, message: 'must be greater than 0' }, allow_blank: true
  

  #validates_format_of :seller_name, presence: true, :with => /\A[^0-9`!@#\$%\^&*+_=]+\z/
  #validates_format_of :seller_country_code, presence: true #:with => (/\A^[\+][0-9]{2,3}$\z/)
  #validates :seller_mobile_number, presence: true
  #validates :seller_email, presence: true #format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "Please use email format"}
  #validates :advertisement_url, format: { with: URI.regexp }, allow_blank: true
  #before_validation :valid_phone_number


  enum status: {'inprogress': 0, 'payment_pending': 1, 'payment_confirmed': 2, 'payment_failed': 3, 'processing': 4, 'completed': 5, 'accepted_for_inspection': 6, 'rejected': 7}
  enum acceptance_status: {'buy': 0, 'rejected': 1}, _prefix: true
  enum instant_deposit_status: {'pending': 0, 'submitted': 1, 'confirmed': 2, 'rejected': 3}, _prefix: true
  enum final_invoice_status: {'pending': 0, 'submitted': 1, 'confirmed': 2, 'rejected': 3}, _prefix: true
  enum payment_link_active: {'Yes': 0, 'No': 1}

  accepts_nested_attributes_for :images, allow_destroy: true
  accepts_nested_attributes_for :inspection_report, allow_destroy: true
  # accepts_nested_attributes_for :other_documents, allow_destroy: true

  def image_url
      return '' unless instant_deposit_receipt.attached?
      instant_deposit_receipt.service.send(:object_for, instant_deposit_receipt.blob.key).public_url
    end
    
  def update_inspection_status
    if saved_change_to_status? && payment_confirmed? && car_ad.present?
      if BxBlockAdmin::VehicleInspection.exists?(car_ad_id: car_ad.id, status: 'completed')
        update_columns(status: 'completed')
      end

    elsif saved_change_to_instant_deposit_status? && instant_deposit_status_confirmed?
      # car_order.update(status: 'instant deposit')
      deactivate_payment_link
      # car_order.update(status: 'final invoice payment')
      BxBlockPushNotifications::PushNotification.create(account_id: self.account_id, remarks: "Your final invoice has been generated. Tap here to view.", notify_type: NOTIFY_TYPE, push_notificable_id: self.account_id, push_notificable_type: ACCOUNT_CLASS_NAME, is_read: false, logo: @base_url, notification_type: "generated", notification_type_id: self.id)
    elsif saved_change_to_status? 
      # if self.status == "accepted_for_inspection"
      #   BxBlockPushNotifications::PushNotification.create(account_id: self.account_id, remarks: "Your inspection request has been scheduled", notify_type: NOTIFY_TYPE, push_notificable_id: self.account_id, push_notificable_type: ACCOUNT_CLASS_NAME, is_read: false, logo: @base_url, notification_type: "inspection scheduled", notification_type_id: self.id)
      if self.status ==  "rejected"
        BxBlockPushNotifications::PushNotification.create(account_id: self.account_id, remarks: "Your request has been rejected. as the car is not available", notify_type: NOTIFY_TYPE, push_notificable_id: self.account_id, push_notificable_type: ACCOUNT_CLASS_NAME, is_read: false, logo: @base_url, notification_type: "inspection rejected", notification_type_id: self.id)
      end
    elsif (saved_change_to_instant_deposit_link? || self.instant_deposit_link.present?)  && !self.instant_deposit_link.blank? && self.final_sale_amount.present? && self.instant_deposit_amount.present?
      if BxBlockPushNotifications::PushNotification.find_by(account_id: self.account_id, notification_type_id: self.id, notification_type: "inspection instant deposit link").blank?
        BxBlockPushNotifications::PushNotification.create(account_id: self.account_id, remarks: "Notification regarding instant deposit link and payment", notify_type: NOTIFY_TYPE, push_notificable_id: self.account_id, push_notificable_type: ACCOUNT_CLASS_NAME, is_read: false, logo: @base_url, notification_type: "inspection instant deposit link", notification_type_id: self.id)
          update_columns(status_updated_at: Time.now)
      end
    end

  end

  def generate_instant_payment_link
    if instant_deposit_amount_changed? && instant_deposit_amount.to_f > 0.0
      if stripe_payment_link_id.present? && instant_deposit_link.present? && payment_link_active == 'Yes'
        deactivate_payment_link
      end
      create_instant_payment_link
    end
  end

  def create_instant_payment_link
    metadata = {type: 'BxBlockAdmin::VehicleInspection', id: self.id, name: 'Instant Deposit', account_id: self.account_id}
    req_amount = (self.instant_deposit_amount * 100).to_i
    link_res = generate_payment_link('Vehicle Instant Deposit', req_amount, metadata)

    if link_res.present?
      update_columns(instant_deposit_link: link_res.url, payment_link_active: 0, stripe_payment_link_id: link_res.id)
    end
  end

  def deactivate_payment_link
    if stripe_payment_link_id.present?
      response = update_payment_link(stripe_payment_link_id, false)
      if response.present? && response&.id.present? && response&.active.blank?
       update_columns(payment_link_active: 1)
      end
    end
  end

  private

  def set_inspection_scheduled_on
    self.inspection_scheduled_on = Date.current
    BxBlockPushNotifications::PushNotification.create(account_id: self.inspector_id, remarks: "You have received a request for inspection", notify_type: NOTIFY_TYPE, push_notificable_id: self.inspector_id, push_notificable_type: ACCOUNT_CLASS_NAME, is_read: false, logo: @base_url, notification_type: "notification of inspector", notification_type_id: self.id)
    BxBlockPushNotifications::PushNotification.create(account_id: self.account_id, remarks: "Your inspection request has been scheduled", notify_type: NOTIFY_TYPE, push_notificable_id: self.account_id, push_notificable_type: ACCOUNT_CLASS_NAME, is_read: false, logo: @base_url, notification_type: "inspection scheduled", notification_type_id: self.id)
    self.status = 'inprogress'
  end
  
  def create_car_order
    #if car_ad.blank?
      state = city&.state
      country = state&.country
      full_number = ''
      if self.seller_country_code.present? && self.seller_mobile_number.present?
        full_number  =  self.seller_country_code + self.seller_mobile_number
        seller_country_code =  self.seller_country_code
        seller_mobile_number = self.seller_mobile_number
      elsif car_ad.present?
        seller_country_code  = account.country_code
        seller_mobile_number = account.phone_number
        full_number  =  seller_country_code + seller_mobile_number
      end
      attr = {
        country: country&.name,
        state: state&.name,
        area: city&.name,
        phone_number: seller_mobile_number,
        account_id: account_id,
        status: 'inspection requested',
        final_sale_amount: final_sale_amount,
        vehicle_inspection_id: id,
        continent: country&.region&.name,
        country_code: seller_country_code,
        full_phone_number: full_number
      }
      obj = BxBlockOrdercreation3::CarOrder.new(attr)
      obj.save
    #end
  end
  def valid_phone_number
    if seller_country_code.present? && seller_mobile_number.present?
      number  = seller_country_code + seller_mobile_number
      unless Phonelib.valid?(number)
        errors.add(:seller_mobile_number, "Please enter valid Mobile Number")
      end
    end
  end


end
