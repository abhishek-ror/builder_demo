module BxBlockMixpanelIntegration
  class MixpanelIntegrationsController < ApplicationController
    
    def total_project
      @total_projects = BxBlockProfile::Project.all
      render json: {projects_: @total_projects, total_projects: @total_projects.count}, status: :ok
    end    

    def total_account
      @total_accounts = AccountBlock::Account.all
      render json: {accounts_details: @total_accounts, total_accounts: @total_accounts.count}, status: :ok
    end

    def total_post
      @total_posts = BxBlockPosts::Post.all
      render json: {posts: @total_posts, total_posts: @total_posts.count}, status: :ok
    end

    def total_car_ads
      @total_car_ads = BxBlockAdmin::CarAd.all
      render json: {car_ads: @total_car_ads, total_car_ads: @total_car_ads.count}, status: :ok
    end

    def total_award
      @total_awards = BxBlockProfile::Award.all
      render json: {awards: @total_awards, total_awards: @total_awards.count}, status: :ok
    end

    def total_car_order
      @total_car_orders = BxBlockOrdercreation3::CarOrder.all
      render  json: {car_order: @total_car_orders, total_car_order: @total_car_orders.count}, status: :ok
    end

    def country_base_accounts
      result = []
      accounts = AccountBlock::Account.select(:country).group(:country).having("count(*) > 0").size
      accounts.each do |key, value|
        result << { key => value }
      end
      render json: {country: result}, status: 200
    end

  end
end

def format_activerecord_errors(errors)
        result = []
        errors.each do |attribute, error|
          result << { attribute => error }
        end
        result
      end