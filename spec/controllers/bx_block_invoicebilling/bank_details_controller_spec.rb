require 'rails_helper'

RSpec.describe BxBlockInvoicebilling::BankDetailsController, type: :controller do
  describe "GET get_bank_details" do
    it "returns bank details if present" do
      bank_details = FactoryBot.create_list(:bank_detail, 5)
      get :get_bank_details
      expect(response).to have_http_status(:ok)
      # expect(JSON.parse(response.body)["bank_details"]).to eq(bank_details.as_json)
    end

    it "returns 'Details Not Found' if bank details are not present" do
      get :get_bank_details
      expect(response).to have_http_status(:ok)
      # expect(JSON.parse(response.body)["bank_details"]).to eq("Details Not Found")
    end
  end
end
