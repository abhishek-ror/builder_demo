require 'rails_helper'
RSpec.describe ::BxBlockLanguageOptions::ApplicationMessage, type: :model do
  describe 'associations' do
    it { should have_many(:translations).class_name('BxBlockLanguageOptions::ApplicationMessage::Translation') }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'nested attributes' do
    it { should accept_nested_attributes_for(:translations).allow_destroy(true) }
  end

  describe '.translation_message' do
    it 'returns the message for the given key if present' do
      application_message = create(:application_message, name: 'test_key', message: 'Test Message')
      result = described_class.translation_message('test_key')
      expect(result).to eq('Test Message')
    end
	it 'returns a fallback message if the key is not present' do
	  result = described_class.translation_message('nonexistent_key')
	  expect(result).to eq('Translation not present for key: nonexistent_key')
	end
  end

  describe '.set_message_for' do
    it 'updates the message for the given key and locale if present' do
      application_message = create(:application_message, name: 'test_key')
      described_class.set_message_for('test_key', :en, 'Updated Message')
      application_message.reload
      expect(application_message.message).to eq('Updated Message')
    end
	it 'raises an error if the key is not present' do
	  expect {
	    described_class.set_message_for('nonexistent_key', :en, 'Updated Message')
	  }.to raise_error('Translation not present for key: nonexistent_key')
	end

  end
end
