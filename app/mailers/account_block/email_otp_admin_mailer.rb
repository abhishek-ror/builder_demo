module AccountBlock
	class EmailOtpAdminMailer < ApplicationMailer
		def otp_email_admin
			otp_details = params[:otp]
			@otp = otp_details.pin
      @host = Rails.env.development? ? 'http://localhost:3000' : params[:host]
      @registration_url = BxBlockAdminEmailNotification::AdminEmailNotification.find_by(notification_name: "Inspector Registration - Account verification")&.content
      if @registration_url.present?
        doc = Nokogiri::HTML::DocumentFragment.parse(@registration_url)
        @image_urls = doc.css('img').map { |img| img['src'] }.compact

        puts "Image URL: #{@image_urls}" if @image_urls.present?
      else
        puts "No content found."
      end
      
      mail(
          to: AdminUser.pluck(:email),
          from: 'builder.bx_dev@engineer.ai',
          subject: 'Inspector Account Confirmation') do |format|
        format.html { render 'otp_email_admin' }
      end
		end
	end
end