require 'rails_helper'

RSpec.describe BxBlockPlan::PlansController, type: :controller do
  describe 'GET index' do
    let!(:plans) { create_list(:plan, 2) }
    it 'returns a list of plans' do
      get :index
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      # expect(json_response['plans'].length).to eq(plans.length)
    end

    it 'returns an empty list if no plans are found' do
      BxBlockPlan::Plan.destroy_all
      get :index
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['data']).to be_empty
    end
  end

  describe 'POST create_user_subsciption' do
    let!(:account) { create(:account) }
    let!(:plan) { create(:plan) }
    let!(:bx_block_plan_user_subscription) { create(:bx_block_plan_user_subscription, plan: plan, account: account) }

    context 'show' do
      before do
        request.headers["token"] = login_user(account)
        post :create_user_subsciption, params: { plan_id: plan.id }
      end
      it 'creates a user subscription and returns a success response' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq("You have requested for #{plan.duration.singularize} Plan")
      end
    end
  end
end