require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers

RSpec.describe Admin::EmailNotificationsController, type: :controller do
render_views

  before(:each) do
  		@account = create(:account)
      @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Admin')
      @admin = create(:admin_user)
      sign_in @admin
      @email_notification = create(:admin_email_notification)
  end

  describe 'GET#index' do
      it 'displays the notification name and content' do
        get :index 
        expect(response).to have_http_status(200)
      end 
  end

  describe 'GET#show' do
    it 'show notification name and content' do
      get :show, params: { id: @email_notification.id }
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST#edit' do
    let!(:params) do {
      notification_name: "Selling flow ads OTP",
      content: "test",
      id: @email_notification.id
    } 
    end

    it 'creates a notification name and content' do
      post :edit, params: params
      expect(response).to have_http_status(200)
    end 
  end
    
end