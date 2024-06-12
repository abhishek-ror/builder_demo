class CreateBxBlockAdminInspectionReports < ActiveRecord::Migration[6.0]
  def change
    create_table :inspection_reports do |t|
      t.string :google_drive_url
      t.references :vehicle_inspection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
