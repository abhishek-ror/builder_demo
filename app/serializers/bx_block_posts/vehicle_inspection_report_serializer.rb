class BxBlockPosts::VehicleInspectionReportSerializer < BuilderBase::BaseSerializer
  attributes :google_drive_url, :id

  attribute :inspection_forms do |object|
    object&.inspection_forms.as_json(only: [:id, :image, :item_type])
  end

  attribute :reports do |object|
    object&.reports.as_json(only: [:id, :image, :item_type])
  end

  attribute :images do |object|
    object&.images.as_json(only: [:id, :image, :item_type])
  end

end