require 'rails_helper'

RSpec.describe "BxBlockMixpanelIntegration::MixpanelService", type: :services do 
    it 'Should create Mixpanel Account' do 
        @account = create(:account)
        mixpanel_service = BxBlockMixpanelIntegration::MixpanelService.new
        mixpanel_service.find_or_create_account(@account)
    end
end
