FactoryBot.define do
  factory :cta do
    headline { "Sample Headline" }
    text_alignment { "centre" }
    button_alignment { "left" }
    button_text { "Sample Button" }
    redirect_url { "https://example.com" }
  end
end
