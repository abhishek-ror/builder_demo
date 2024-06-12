require 'rails_helper'

RSpec.describe BxBlockServices::Service, type: :model do

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end

  describe 'associations' do
    it { should have_one_attached(:logo) }
  end

  describe '#logo_url' do
    # it 'returns the logo URL if logo is attached' do
    #   service = create(:service)
    #   expect(service.logo_url).to eq(service.logo.service_url.split('?').first)
    # end
	it 'returns the default logo URL if logo is not attached' do
	  service = build(:service, logo: nil)
	  expect(service.logo_url).to eq("#{ActiveStorage::Current.host}/images/missing.jpg")
	end

  end

end