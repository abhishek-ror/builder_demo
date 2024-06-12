require 'rails_helper'
require 'swagger_helper'
RSpec.describe "MixpanelIntegrations", type: :request do
  CONTENT_TYPE = 'application/json'.freeze
  describe "MixpanelIntegrations Api" do

    path '/bx_block_mixpanel_integration/mixpanel_integrations/country_base_accounts' do
      get 'Get country_base_accounts' do
        tags :mixpanelintegrations
        produces CONTENT_TYPE
        response '200', 'Return all the available country_base_accounts' do
          it 'Return success country_base_accounts' do
            body = JSON(response.body)
            expect(response).to have_http_status(200)
          end
          run_test!
        end
      end
    end

    path '/bx_block_mixpanel_integration/mixpanel_integrations/total_project' do
      get 'Get total_project' do
        tags :mixpanelintegrations
        produces CONTENT_TYPE
        response '200', 'Return all the available total_project' do
          it 'Return success total_project' do
            body = JSON(response.body)
            expect(response).to have_http_status(200)
          end
          run_test!
        end
      end
    end

    path '/bx_block_mixpanel_integration/mixpanel_integrations/total_account' do
      get 'Get total_account' do
        tags :mixpanelintegrations
        produces CONTENT_TYPE
        response '200', 'Return all the available total_account' do
          it 'Return success total_account' do
            body = JSON(response.body)
            expect(response).to have_http_status(200)
          end
          run_test!
        end
      end
    end

    path '/bx_block_mixpanel_integration/mixpanel_integrations/total_post' do
      get 'Get total_post' do
        tags :mixpanelintegrations
        produces CONTENT_TYPE
        response '200', 'Return all the available total_post' do
          it 'Return success total_post' do
            body = JSON(response.body)
            expect(response).to have_http_status(200)
          end
          run_test!
        end
      end
    end

    path '/bx_block_mixpanel_integration/mixpanel_integrations/total_car_ads' do
      get 'Get total_car_ads' do
        tags :mixpanelintegrations
        produces CONTENT_TYPE
        response '200', 'Return all the available total_car_ads' do
          it 'Return success total_car_ads' do
            body = JSON(response.body)
            expect(response).to have_http_status(200)
          end
          run_test!
        end
      end
    end

    path '/bx_block_mixpanel_integration/mixpanel_integrations/total_award' do
      get 'Get total_award' do
        tags :mixpanelintegrations
        produces CONTENT_TYPE
        response '200', 'Return all the available total_award' do
          it 'Return success total_award' do
            body = JSON(response.body)
            expect(response).to have_http_status(200)
          end
          run_test!
        end
      end
    end

    path '/bx_block_mixpanel_integration/mixpanel_integrations/total_car_order' do
      get 'Get total_car_order' do
        tags :mixpanelintegrations
        produces CONTENT_TYPE
        response '200', 'Return all the available total_car_order' do
          it 'Return success total_car_order' do
            body = JSON(response.body)
            expect(response).to have_http_status(200)
          end
          run_test!
        end
      end
    end

    path '/bx_block_mixpanel_integration/mixpanel_integrations/country_base_accounts' do
      get 'Get country_base_accounts' do
        tags :mixpanelintegrations
        produces CONTENT_TYPE
        response '200', 'Return all the available country_base_accounts' do
          it 'Return success country_base_accounts' do
            body = JSON(response.body)
            expect(response).to have_http_status(200)
          end
          run_test!
        end
      end
    end
  end
end
