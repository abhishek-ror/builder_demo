class BxBlockAdmin::VehicleSellingInspection < ApplicationRecord
  self.table_name = :vehicle_selling_inspections
  include StripePaymentLink

  default_scope { order('id DESC') }

  belongs_to :city, optional: true
  belongs_to :vehicle_selling, class_name: 'BxBlockVehicleShipping::VehicleSelling', optional: true, foreign_key: :vehicle_selling_id
  belongs_to :inspector, class_name: 'AccountBlock::Account', optional: true, foreign_key: :inspector_id
  belongs_to :account, class_name: 'AccountBlock::Account', optional: true, foreign_key: :account_id
  belongs_to :admin_user, class_name: 'AdminUser',optional: true
  has_one :inspection_report, dependent: :destroy
  has_many :inspection_reports, dependent: :destroy
  # has_one_attached :payment_receipt
  # has_one_attached :document
  has_one_attached :instant_deposit_receipt
  has_many_attached :auto_images
  has_many :images, as: :attached_item, class_name: 'BxBlockContentManagement::Image'
  # has_many :other_documents, -> { where(item_type: 'other_documents') }, as: :attached_item, class_name: 'BxBlockContentManagement::Image'
  has_one :vehicle_order, class_name: 'BxBlockVehicleShipping::VehicleOrder'

  after_create :create_vehicle_order
  after_update :update_inspection_status
  before_update :generate_instant_payment_link

  validates :city_id, presence: true
  validates :account_id, presence: true
  # validates :inspector_id, presence: true
  # validates :seller_name, presence: true
  # validates :seller_country_code, presence: true
  # validates :seller_mobile_number, presence: true
  # validates :seller_email, presence: true
  # validates :inspection_amount, presence: true
  #validates_format_of :seller_name, presence: true, :with => /\A[^0-9`!@#\$%\^&*+_=]+\z/
  #validates_format_of :seller_country_code, presence: true #:with => (/\A^[\+][0-9]{2,3}$\z/)
  #validates :seller_mobile_number, presence: true
  #validates :seller_email, presence: true #format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "Please use email format"}
  validates :price, presence: true #numericality: { only_numeric: true }
  #validates :inspection_amount, presence: true #numericality: { only_numeric: true }
  #validates :instant_deposit_amount, numericality: { only_numeric: true }, allow_blank: true
  #validates :final_sale_amount, numericality: { only_numeric: true }, allow_blank: true
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
    if saved_change_to_status? && payment_confirmed? && vehicle_selling.present?
      if BxBlockAdmin::VehicleSellingInspection.exists?(vehicle_selling_id: vehicle_selling.id, status: 'completed')
        update_columns(status: 'completed')
      end

    elsif saved_change_to_instant_deposit_status? && instant_deposit_status_confirmed? && vehicle_order.present?
      vehicle_order.update(status: 'instant deposit')
      deactivate_payment_link

    elsif saved_change_to_final_invoice_status? && final_invoice_status_confirmed? && vehicle_order.present?
      vehicle_order.update(status: 'final invoice payment')
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
    metadata = {type: 'BxBlockAdmin::VehicleSellingInspection', id: self.id, name: 'Instant Deposit', account_id: self.account_id}
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
  def create_vehicle_order
    #if vehicle_selling.blank?
      state = city&.state
      country = state&.country
      full_number = ''
      if self.seller_country_code.present? && self.seller_mobile_number.present?
        full_number  =  self.seller_country_code + self.seller_mobile_number
        seller_country_code =  self.seller_country_code
        seller_mobile_number = self.seller_mobile_number
      elsif vehicle_selling.present?
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
        vehicle_selling_inspection_id: id,
        continent: country&.region&.name,
        country_code: seller_country_code,
        full_phone_number: full_number
      }
      obj = BxBlockVehicleShipping::VehicleOrder.new(attr)
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
