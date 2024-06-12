module BxBlockWhatsappNumber
  class WhatsappNumbersController < ApplicationController
   def index
	  @whatsapp_number = BxBlockWhatsappNumber::WhatsAppNumber.first
	  render json: @whatsapp_number
   end
  end
end
