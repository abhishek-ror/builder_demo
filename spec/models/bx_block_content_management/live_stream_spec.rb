require 'rails_helper'
RSpec.describe ::BxBlockContentManagement::LiveStream, type: :model do
  describe 'validation' do
    it { should validate_presence_of(:headline) }
  end
end