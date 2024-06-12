require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers

RSpec.describe Admin::AddPortsController, type: :controller do
  render_views
  before(:each) do
    @admin = create(:admin_user)
    @account = create(:account)
    @country = create(:country)
    @port = BxBlockAdmin::Port.create(country_id: @country.id)
    sign_in @admin
  end

  let(:port_params) { { port_name: 'Test Port', country_id: @country.id } }

  describe "GET #new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    it "creates a new port with valid parameters" do
      expect {
        post :create, params: { port: port_params }
      }.to change(BxBlockAdmin::Port, :count).by(1)
    end
  end

end