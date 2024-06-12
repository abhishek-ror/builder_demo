# frozen_string_literal: true

module BxBlockPlan
  class PlansController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token, except: [:index]

    def index
      plans = BxBlockPlan::Plan.where.not("name ilike ?", "%free%").order("ad_count asc")
      if plans.present?
        render json: { plans: plans, message: 'Successfully Loaded' }
      else
        render json: { data: [] },
               status: :ok
      end
    end

    def create_user_subsciption
      record = current_user.user_subscriptions.new(plan_id: params[:plan_id], status: "pending")
      if record.save
        render json: {message: "You have requested for #{record.plan.duration.singularize} Plan"}
      end

    end

  end
end
