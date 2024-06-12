class BxBlockAdmin::InspectionReport < ApplicationRecord
  self.table_name = :inspection_reports
  belongs_to :vehicle_inspection

  has_many :images, -> { where(item_type: 'images') }, as: :attached_item, class_name: 'BxBlockContentManagement::Image'
  accepts_nested_attributes_for :images, allow_destroy: true
  
  has_many :inspection_forms, -> { where(item_type: 'inspection_forms') }, as: :attached_item, class_name: 'BxBlockContentManagement::Image'
  accepts_nested_attributes_for :inspection_forms, allow_destroy: true
  
  has_many :reports, -> { where(item_type: 'reports') }, as: :attached_item, class_name: 'BxBlockContentManagement::Image'
  accepts_nested_attributes_for :reports, allow_destroy: true

  after_save :check_push_notification 

  def check_push_notification
  	if (saved_change_to_google_drive_url? && !self.google_drive_url.blank?) || self.inspection_forms.present? && self.vehicle_inspection.inspection_invoice.present?
      self.vehicle_inspection.update(status: 5)
      BxBlockPushNotifications::PushNotification.create(account_id: self.vehicle_inspection.account_id, remarks: "Your inspection report has been updated.", notify_type: "Inspection Report", push_notificable_id: self.vehicle_inspection.account_id, push_notificable_type: "AccountBlock::Account", is_read: false, logo: @base_url, notification_type: "inspection updated", notification_type_id: self.vehicle_inspection.id)
    end
  end
end