require 'rails_helper'

RSpec.describe BxBlockRolesPermissions::Role, type: :model do

  describe 'validations' do
    it { should validate_uniqueness_of(:name).with_message('Role already present') }
  end

  describe 'associations' do
    it { should have_many(:accounts).class_name('AccountBlock::Account')}
  end

end