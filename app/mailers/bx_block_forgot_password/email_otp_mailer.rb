module BxBlockForgotPassword
  class EmailOtpMailer < ApplicationMailer
    def otp_email
      @otp = params[:otp]
      @host = Rails.env.development? ? 'http://localhost:3000' : params[:host]
      @selling_flow_content = BxBlockAdminEmailNotification::AdminEmailNotification.find_by(notification_name: "Selling flow ads OTP")&.content
      mail(
          to: @otp.email,
          from: 'builder.bx_dev@engineer.ai',
          subject: 'Your OTP code') do |format|
        format.html { render 'otp_email' }
      end
    end
  end
end
