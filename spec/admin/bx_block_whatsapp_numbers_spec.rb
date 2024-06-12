require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers
RSpec.describe Admin::WhatsAppsController, type: :controller do

	render_views

    before(:each) do
        @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Admin')
        @admin = create(:admin_user)
        @whatsapp_number = BxBlockWhatsappNumber::WhatsAppNumber.create(whatsapp_number: '1234567890')
        sign_in @admin
    end

    describe "Get#show" do
	    it "show whatsapp_number details" do
	      get :show, params: {id:  @whatsapp_number.id}
	      expect(response).to have_http_status(200)
	    end
  	end

  	describe 'GET#index' do
        it 'shows all labels' do
          get :index 
          expect(response).to have_http_status(200)
        end 
    end

    describe 'POST#edit' do
	    let!(:params) do {
	      whatsapp_number: "0987654321"
	    } 
	    end

	    it 'edit a account' do
	      put :edit, params: { id: @whatsapp_number.id, whatsapp_number: params }
	      expect(response).to have_http_status(200)
	    end 
  	end
end