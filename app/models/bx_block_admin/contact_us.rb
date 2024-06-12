module BxBlockAdmin
  class ContactUs < BxBlockAdmin::ApplicationRecord
    self.table_name = :contact_us
    validates :description, presence: true
    validates :email, presence: true, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "Please use email format"}
  end
end
