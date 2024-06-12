module BxBlockMixpanelIntegration
  class MixpanelIntegration < BxBlockMixpanelIntegration::ApplicationRecord
    self.table_name = :bx_block_mixpanel_integration_mixpanel_integrations
    validates :project_count, numericality: { only_integer: true }
  end
end
