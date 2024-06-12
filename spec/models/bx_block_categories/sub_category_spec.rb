require 'rails_helper'
RSpec.describe ::BxBlockCategories::SubCategory, type: :model do
  	describe 'associations' do
   	 	it { should have_and_belong_to_many(:categories).join_table(:categories_sub_categories).dependent(:destroy) }

   	 	it { should have_many(:sub_categories).class_name( "BxBlockCategories::SubCategory").dependent(:destroy) }
   		 it { should have_many(:user_sub_categories).class_name( "BxBlockCategories::UserSubCategory").dependent(:destroy) }
    	it { should have_many(:accounts).class_name( "AccountBlock::Account").through(:user_sub_categories) }
  	end

 	 describe "validations" do
   		 it { should validate_presence_of(:name) }
	end
end