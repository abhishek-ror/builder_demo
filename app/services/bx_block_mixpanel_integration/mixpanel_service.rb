require 'mixpanel-ruby'

module BxBlockMixpanelIntegration
	class MixpanelService

		def initialize
			@tracker = Mixpanel::Tracker.new("32b580161e16a08a76681d969d975d40")
		end

		def find_or_create_account(account)
			@tracker.people.append(account.email, {
		    '$first_name'       	=> account.first_name.present? ? account.first_name : account.full_name,
		    '$last_name'        	=> account.last_name.present? ? account.last_name : '',
		    '$email'            	=> account.email,
		    'phone_number'        => account.phone_number,
		    'Role_id'    					=> account.role_id,
		    'country_code'				=>account.country_code
			})
		end
	end
end