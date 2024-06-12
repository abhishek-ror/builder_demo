require 'rails_helper'
RSpec.describe ::BxBlockSubscription::SubscriptionsController, type: :controller do
	
	describe 'show' do 
		let!(:account) { create(:account) }
    	let!(:plan) { create(:plan) }

    	context 'show' do
      		before do
        		request.headers["token"] = login_user(account)
        		get :show
      		end
     		it 'When user does not have any plan' do
        		expect(JSON.parse(response.body)['message']).to eq("subscription plan")
        		expect(response.code).to eq('200')
      		end	
   		end
   	end


   	describe 'show' do 
   		let!(:account) { create(:account) }
    	let!(:plan) { create(:plan) }
    	let!(:bx_block_plan_user_subscription) { create(:bx_block_plan_user_subscription, plan: plan, account: account) }

    	context 'show' do
      		before do
        		request.headers["token"] = login_user(account)
        		get :show
      		end
     		it 'When user does have subscribed to plan' do
        		expect(JSON.parse(response.body)['message']).to eq("subscription plan")
        		expect(JSON.parse(response.body)['response']['plan']).to eq(account.user_subscriptions.first.plan.name)
        		expect(response.code).to eq('200')
      		end	
   		end
   	end

   	describe 'save' do 
		let!(:account) { create(:account) }
    	let!(:plan) { create(:plan) }

    	context 'save' do
      		before do
        		request.headers["token"] = login_user(account)
        		post :save, params: {plan: plan.name}
      		end
     		it 'When user does not have any plan' do
        		expect(JSON.parse(response.body)['message']).to eq("subscription plan updated")
        		expect(response.code).to eq('200')
      		end	
   		end
   	end
end