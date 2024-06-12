require 'rails_helper'
RSpec.describe ::AccountBlock::Account, type: :model do

	context "association test" do
		it "should has_one blacklist user" do
			t = AccountBlock::Account.reflect_on_association(:blacklist_user)
			expect(t.macro).to eq(:has_one)
		end
		it "should has_one profile" do 
			t = AccountBlock::Account.reflect_on_association(:profile)
			expect(t.macro).to eq(:has_one)
		end
		it "should has_one address" do 
			t = AccountBlock::Account.reflect_on_association(:address)
			expect(t.macro).to eq(:has_one)
		end
		it "should has_many car_ads" do 
			t = AccountBlock::Account.reflect_on_association(:car_ads)
			expect(t.macro).to eq(:has_many)
		end
		it "should has_many favourites" do 
			t = AccountBlock::Account.reflect_on_association(:favourites)
			expect(t.macro).to eq(:has_many)
		end
		it "should has_many favourite_car_ads" do 
			t = AccountBlock::Account.reflect_on_association(:favourite_car_ads)
			expect(t.macro).to eq(:has_many)
		end
		it "should has_many car_orders" do 
			t = AccountBlock::Account.reflect_on_association(:car_orders)
			expect(t.macro).to eq(:has_many)
		end
		it "should has_many shipments" do 
			t = AccountBlock::Account.reflect_on_association(:shipments)
			expect(t.macro).to eq(:has_many)
		end
		it "should has_many vehicle_shippings" do 
			t = AccountBlock::Account.reflect_on_association(:vehicle_shippings)
			expect(t.macro).to eq(:has_many)
		end
		it "should has_many user_subscriptions" do 
			t = AccountBlock::Account.reflect_on_association(:user_subscriptions)
			expect(t.macro).to eq(:has_many)
		end
		it "should has_many vehicle_inspections" do 
			t = AccountBlock::Account.reflect_on_association(:vehicle_inspections)
			expect(t.macro).to eq(:has_many)
		end
		it "should has_many credit_cards" do 
			t = AccountBlock::Account.reflect_on_association(:credit_cards)
			expect(t.macro).to eq(:has_many)
		end
		it "should has_many inspector_inspections" do 
			t = AccountBlock::Account.reflect_on_association(:inspector_inspections)
			expect(t.macro).to eq(:has_many)
		end

		describe '#create_on_stripe' do
		    let(:account) { FactoryBot.create(:account) }

		    it 'creates a customer on Stripe with the correct parameters' do
		      expect(Stripe::Customer).to receive(:create).with(
		        email: 'email',
		        name: account.full_name || account.company_name
		      ).and_return(double(id: 'customer_id'))
		      account.send(:create_on_stripe)
		      expect(account.stripe_id).to eq('customer_id')
		    end
  		end

  		describe '#parse_full_phone_number' do
		    let(:account) { FactoryBot.create(:account, full_phone_number: '917887886475') }

		    it 'parses the phone number and sets the appropriate attributes' do
		      account.send(:parse_full_phone_number)
		      expect(account.full_phone_number).to eq('917887886475')
		      expect(account.country_code).to eq(91)
		      expect(account.phone_number).to eq(7887886475)
		    end
  		end
	end

end

