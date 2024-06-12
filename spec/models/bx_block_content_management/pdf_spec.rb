require 'rails_helper'
RSpec.describe ::BxBlockContentManagement::Pdf, type: :model do

  describe "validations" do
    it { should validate_presence_of(:pdf) }
  end 

  describe "associations" do
    it { should belong_to(:attached_item) }
  end 

end