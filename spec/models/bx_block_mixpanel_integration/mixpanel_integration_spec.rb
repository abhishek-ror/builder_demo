require 'rails_helper'

RSpec.describe BxBlockMixpanelIntegration::MixpanelIntegration, type: :model do
  it "is not valid string" do
    subject { BxBlockMixpanelIntegration::MixpanelIntegration.new(project_count: "abc") }
    expect(subject).to_not be_valid
  end
end
