require 'rails_helper'

RSpec.describe BxBlockWhatsappNumber::WhatsappNumbersController, type: :controller do

  before do
    whatsapp = BxBlockWhatsappNumber::WhatsAppNumber.create(whatsapp_number: '1234567890')
  end
  describe 'GET #index' do
    it 'renders the WhatsApp number as JSON' do
      get :index

      expect(response).to have_http_status(:success)
    end
  end
end
