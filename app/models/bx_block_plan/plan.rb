# frozen_string_literal: true

module BxBlockPlan
  class Plan < BxBlockPlan::ApplicationRecord
    self.table_name = :plans
    enum duration: ['1 Months', '3 Months', '6 Months', '1 Years']
    has_many :user_subscriptions, class_name: "BxBlockPlan::UserSubscription", dependent: :destroy
    validate :create_only_three, on: :create
    validates :name, presence: true
    # validates :duration, presence: true
    # validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :details, presence: true
    validates :ad_count, presence: true

    private

    def create_only_three
      errors.add(:base, "You can't create more than three plans.") if BxBlockPlan::Plan.count > 4
    end
  end
end
