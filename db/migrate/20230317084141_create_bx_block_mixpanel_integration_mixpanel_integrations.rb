class CreateBxBlockMixpanelIntegrationMixpanelIntegrations < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_mixpanel_integration_mixpanel_integrations do |t|
      t.integer :project_count
      t.integer :account_count
      t.integer :post_count
      t.integer :car_ads_count
      t.integer :award_count
      t.timestamps
    end
  end
end
