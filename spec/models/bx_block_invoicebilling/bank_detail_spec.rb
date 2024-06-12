require 'rails_helper'

RSpec.describe BxBlockInvoicebilling::BankDetail, type: :model do
  subject(:bank_detail) { described_class.new }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:account_no) }
    it { is_expected.to validate_numericality_of(:account_no).only_integer }
    it { is_expected.to validate_length_of(:account_no).is_at_least(1).is_at_most(20) }

    it { is_expected.to validate_presence_of(:fze_bank_name) }
    it { is_expected.to validate_presence_of(:emirates_nbd_swift) }
    it { is_expected.to validate_presence_of(:euro_account_name) }
    it { is_expected.to validate_presence_of(:iban) }
  end
end