module BxBlockNotifications
  class Notification < ApplicationRecord
    self.table_name = :notifications
    belongs_to :account , class_name: 'AccountBlock::Account', foreign_key: 'account_id'
    belongs_to :created_user, class_name: 'AccountBlock::Account', foreign_key: 'created_by'

    validates :headings, :contents, :account_id, presence: true, allow_blank: false
  end
end