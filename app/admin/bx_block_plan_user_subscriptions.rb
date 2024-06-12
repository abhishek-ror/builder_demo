ActiveAdmin.register BxBlockPlan::UserSubscription, as: "User Subscription Requests" do
  permit_params :account_id, :plan_id, :status
  # config.sort_order = 'updated_at_desc'
  scope :all, default: true
  scope :activated
  scope :pending
  scope :expired

  index do
    selectable_column
    id_column
    column :account do |record|
      link_to("#{record&.account&.full_name}","/admin/accounts/#{record&.account&.id}") 
    end
    column :plan do |record|
      link_to("#{record&.plan&.name}","/admin/plans/#{record&.plan&.id}") 
    end
    column :status
    # column :created_at
    # column :updated_at
    column :start_date
    column :expiry_date
    actions
  end
end