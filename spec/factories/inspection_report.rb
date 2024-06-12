FactoryBot.define do
    factory :inspection_report, class: 'BxBlockAdmin::InspectionReport' do
        google_drive_url { "http:/google.com" }
    end
  end
  