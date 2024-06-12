class BxBlockPlan::UserSubscription < ApplicationRecord
  self.table_name = :user_subscriptions
  has_many :car_ads, class_name: "BxBlockAdmin::CarAd"
  belongs_to :account, class_name: "AccountBlock::Account"
  belongs_to :plan, class_name: "BxBlockPlan::Plan"
  enum status: { pending: 0, activated: 1 , expired: 2}

  before_save :update_start_and_expiry_dates
  # before_create :set_start_date
  before_update :set_acccount_ads
  validates :status, presence: true

  def set_start_date
    if plan&.duration.present?
      plan_duration_array = plan.duration.downcase.split(' ')
      self.start_date = Date.today
      self.expiry_date = Date.today + plan_duration_array.first.to_i.send(plan_duration_array.second)
    end
  end
  def set_acccount_ads
    if self.status == 'activated' && self.plan.name != 'Free Plan'
      total_ads = self.account.total_ads +  self.plan.ad_count
      self.account.update(total_ads: total_ads)
    end
  end

  private
  def update_start_and_expiry_dates
    if plan&.duration.present?
      # self.start_date = Date.today
      # self.expiry_date = Date.today + plan.duration.months
      plan_duration_array = plan.duration.downcase.split(' ')
      self.start_date = Date.today
      self.expiry_date = Date.today + plan_duration_array.first.to_i.send(plan_duration_array.second)
    end
  end
end