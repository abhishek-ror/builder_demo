require 'rails_helper'
RSpec.describe ::BxBlockAdmin::Company, type: :model do
  describe 'associations' do
    it { should have_many(:models).dependent(:destroy) }
    it { should have_one_attached(:logo) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:logo) }
  end

  describe 'logo_validation when logo is present' do
    let!(:company) { create(:company) }
    it 'valid data present' do
        expect(company.logo.attached?).to eq(true)
    end
  end

  describe 'logo_validation when logo is not present' do
    company = BxBlockAdmin::Company.create(name: "audi")
    it 'valid data present' do
        expect(company.logo.attached?).to eq(false)
        # expect(company.logo_url).to eq("/images/missing.jpg")
    end
  end
end
