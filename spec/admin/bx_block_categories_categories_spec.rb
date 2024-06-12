require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers

RSpec.describe Admin::CategoriesController, type: :controller do
  render_views
  before(:each) do
    @admin = create(:admin_user)
    @category = create(:category)
    @sub_category = @category.sub_categories.create(name: "Logo parts")
    sign_in @admin
  end 
   
  describe 'POST#new' do
    let!(:params) do {
      name: "LOGO AND BRAND"
    } 
    end

    it 'creates a category' do
      post :new, params: params
      expect(response).to have_http_status(200)
    end 
  end

  describe 'GET#index' do
    it 'shows all categories' do
      get :index 
      expect(response).to have_http_status(200)
    end 
  end

  describe 'GET#show' do
    it 'show category' do
      get :show, params: { id: @category.id }
      expect(response).to have_http_status(200)
    end
  end
end