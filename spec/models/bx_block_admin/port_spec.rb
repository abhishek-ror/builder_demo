require 'rails_helper'

RSpec.describe BxBlockAdmin::Port, type: :model do
  describe 'associations' do
    it { should belong_to(:country)}
  end
end
