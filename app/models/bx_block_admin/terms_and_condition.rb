module BxBlockAdmin
  class TermsAndCondition < BxBlockAdmin::ApplicationRecord
    self.table_name = :terms_and_conditions
    validates :description, presence: true
  end
end
