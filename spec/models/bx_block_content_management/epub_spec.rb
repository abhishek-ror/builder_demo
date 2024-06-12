require 'rails_helper'
RSpec.describe ::BxBlockContentManagement::Epub, type: :model do
  describe 'validation' do
    it { should validate_presence_of(:heading) }
    it { should validate_presence_of(:description) }   
    
  end

  describe "associations" do
    it { should have_many(:pdfs).class_name('BxBlockContentManagement::Pdf').dependent(:destroy) }
  end

  describe "nested attributes" do
    it { should accept_nested_attributes_for(:pdfs).allow_destroy(true) }
  end
  
end