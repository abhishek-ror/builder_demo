require 'rails_helper'

RSpec.describe ::BxBlockMixpanelIntegration::MixpanelIntegrationsController, type: :controller do

  describe "Get total project" do
    it "Get total user project" do
        get :total_project
        expect(response).to have_http_status(200)
    end
  end

  describe "Get total account" do
    it "Get total user account" do
        get :total_account
        expect(response).to have_http_status(200)
    end
  end

  describe "Get total post" do
    it "Get total user post" do
        get :total_post
        expect(response).to have_http_status(200)
    end
  end

  describe "Get total car_ads" do
    it "Get total user car_ads" do
        get :total_car_ads
        expect(response).to have_http_status(200)
    end
  end

  describe "Get total awards" do
    it "Get total user awards" do
        get :total_award
        expect(response).to have_http_status(200)
    end
  end

  describe "Get total car_order" do
    it "Get total user car_order" do
        get :total_car_order
        expect(response).to have_http_status(200)
    end
  end

  describe "Country Base Account" do
    it "get count of account with country name" do
        get :country_base_accounts
        expect(response).to have_http_status(200)
    end
  end

end

