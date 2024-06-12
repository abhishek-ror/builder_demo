require 'rails_helper'
RSpec.describe ::BxBlockCategories::Category, type: :model do
  # describe 'associations' do
  #   it { should belong_to(:service_provider).class_name('AccountBlock::Account') }
  # end


   subject(:category) { FactoryBot.build(:category) }

  it "is valid with valid attributes" do
    expect(category).to be_valid
  end

  it "validates uniqueness of name" do
    expect(category).to validate_uniqueness_of(:name)
  end

  it "validates uniqueness of identifier" do
    # expect(category).to validate_uniqueness_of(:identifier).allow_blank
  end

  it "has and belongs to many sub_categories" do
    expect(category).to have_and_belong_to_many(:sub_categories)
      .join_table(:categories_sub_categories)
      .dependent(:destroy)
  end

  it "has many contents" do
    expect(category).to have_many(:contents)
      .class_name("BxBlockContentManagement::Content")
      .dependent(:destroy)
  end

  it "has many ctas" do
    expect(category).to have_many(:ctas)
      .class_name("BxBlockCategories::Cta")
      .dependent(:destroy)
  end

  it "has many user_categories" do
    expect(category).to have_many(:user_categories)
      .class_name("BxBlockCategories::UserCategory")
      .join_table("user_categoeries")
      .dependent(:destroy)
  end

  it "has many accounts through user_categories" do
    expect(category).to have_many(:accounts)
      .class_name("AccountBlock::Account")
      .through(:user_categories)
      .join_table("user_categoeries")
  end

  it "accepts nested attributes for sub_categories" do
    expect(category).to accept_nested_attributes_for(:sub_categories).allow_destroy(true)
  end
  
end