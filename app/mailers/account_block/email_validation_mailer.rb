require 'nokogiri'
module AccountBlock
  class EmailValidationMailer < ApplicationMailer
    include ActionView::Helpers::TextHelper
    def activation_email
      @account = params[:account]
      @host = Rails.env.development? ? 'http://localhost:3000' : params[:host]
      
      token = encoded_token
      temporary_token = @account.temporary_token

      # @url = "#{@host}/account_block/accounts/activate_account?token=#{token}"

      # if @account.device_type == 'android'

      #   @url = "https://carshipapp1.page.link/jTpt?temporary_token=#{temporary_token}"
      # else
      #   @url = "carshipapp://NewPassword?temporary_token=#{temporary_token}"
      # end

      if @account.device_type == 'android'
        # Prepare the request body for Firebase API
        firebase_request_data = {
          longDynamicLink: "https://carshipap.page.link?link=https://carshipapp.com?temporary_token=#{temporary_token}&apn=com.CarShipapp1&ibi=ai.builder.pro.carshipapp"
        }

        # Create a new HTTP request for Firebase API
        firebase_api_url = URI.parse("https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyBrQali5rS2le2yP1uSu5pzgnrPgRjxVHI")
        firebase_http = Net::HTTP.new(firebase_api_url.host, firebase_api_url.port)
        firebase_http.use_ssl = true 
        # Firebase API uses HTTPS

        # firebase_request = Net::HTTP::Post.new(firebase_api_url.path)
        firebase_request = Net::HTTP::Post.new("https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyBrQali5rS2le2yP1uSu5pzgnrPgRjxVHI")
        firebase_request.body = JSON.generate(firebase_request_data)
        firebase_request['Content-Type'] = 'application/json'

        # Make the request to Firebase API
        firebase_response = firebase_http.request(firebase_request)

        # Parse the Firebase response
        if firebase_response.code == '200'
          firebase_response_data = JSON.parse(firebase_response.body)
          short_link = firebase_response_data['shortLink']
          @url = short_link
        else
          puts "Firebase API request failed with status: #{firebase_response.code}"
          puts "Response body: #{firebase_response.body}"
        end
      else
        @url = "carshipapp://NewPassword?temporary_token=#{temporary_token}"
      end

      
      

      @new_user_url = BxBlockAdminEmailNotification::AdminEmailNotification.find_by(notification_name:  "Individual & Business - Account Verification (New user)")&.content 

     if @new_user_url.present?
        doc = Nokogiri::HTML::DocumentFragment.parse(@new_user_url)
        @image_urls = doc.css('img').map { |img| img['src'] }.compact

        puts "Image URL: #{@image_urls}" if @image_urls.present?
     else
        puts "No content found."
     end

      mail(
          to: @account.email,
          from: 'builder.bx_dev@engineer.ai',
          subject: 'Account activation') do |format|
        format.html { render 'activation_email' }
      end
    end

    private

    def encoded_token
      BuilderJsonWebToken.encode @account.id, 10.minutes.from_now
    end
  end
end
