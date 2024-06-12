module BxBlockPosts
  class CarAdMailer < ApplicationMailer
    def send_otp
      email = params[:email]
      @otp = params[:otp]
      @host = Rails.env.development? ? 'http://localhost:3000' : params[:host]
      mail(
          to: email,
          from: 'builder.bx_dev@engineer.ai',
          subject: 'OTP verification for posting ad') do |format|
        format.html { render 'send_otp' }
      end
    end
  end
end