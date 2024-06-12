module BxBlockSubscription
  class SubscriptionsController < ApplicationController
    
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :current_user

    def show
      user_subscriptions =  current_user.user_subscriptions.where(status: "activated")
      if user_subscriptions.present?
        ads_total = current_user.user_subscriptions.first
        ads_left = current_user.total_ads - current_user.vehicle_sellings.where(verified: true).count
        response  =  {plan:  user_subscriptions.first.plan.name, ads_left: ads_left}
      else
        ads_left = 3 - current_user.vehicle_sellings.where(verified: true).count
        response = {plan: "free", ads_left: ads_left}
      end
      render json: {message: "subscription plan", response: response}
    end

    def save
      if current_user.user_subscriptions.present?
        plan = BxBlockPlan::Plan.find_by(name: params[:plan])
        current_user.user_subscriptions.update(plan_id: plan.id, status: 0)
      else
        plan = BxBlockPlan::Plan.find_by(name: params[:plan])
        current_user.user_subscriptions.create(plan_id: plan.id, status: 0)
      end
      render json: {message: "subscription plan updated"}
    end

    private 

    def current_user
      @account = AccountBlock::Account.find(@token.id)
    end

  end
end
