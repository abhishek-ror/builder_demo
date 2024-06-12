require 'rails_helper'
RSpec.describe ::BxBlockContentManagement::Content, type: :model do

  describe "associations" do
    it { should belong_to(:category).class_name("BxBlockCategories::Category").with_foreign_key("category_id") }
    it { should belong_to(:sub_category).class_name("BxBlockCategories::SubCategory").with_foreign_key("sub_category_id") }
    it { should belong_to(:content_type).class_name("BxBlockContentManagement::ContentType").with_foreign_key("content_type_id") }
    it { should belong_to(:language).class_name("BxBlockLanguageOptions::Language").with_foreign_key("language_id") }
    it { should belong_to(:contentable).inverse_of(:contentable).autosave(true).dependent(:destroy) }
    it { should belong_to(:author).class_name("BxBlockContentManagement::Author").optional(true) }
    it { should have_many(:bookmarks).class_name("BxBlockContentManagement::Bookmark").dependent(:destroy) }
    it { should have_many(:account_bookmarks).class_name("AccountBlock::Account").through(:bookmarks).source(:account) }
  end

  describe "validations" do
    # it { should validate_presence_of(:author_id) }
    # it { should validate_presence_of(:publish_date) }
    it { should validate_presence_of(:status) }
    # it { should validate_presence_of(:feedback) }

    # it { should validate_on(:update).validate(:validate_publish_date) }
    # it { should validate_on(:update).validate(:validate_status) }
    # it { should validate_on(:update).validate(:validate_content_type) }
    # it { should validate_on(:update).validate(:validate_approve_status) }
    # it { should validate_on(:update).validate(:max_tag_char_length) }
  end

  describe "scopes" do
    it "returns operations_l1_content scope" do
      expect(described_class.operations_l1_content.to_sql).to eq(described_class.where(review_status: ["pending", "rejected", "submit_for_review"]).to_sql)
    end

    it "returns submit_for_review_l1_content scope" do
      expect(described_class.submit_for_review_l1_content.to_sql).to eq(described_class.where(review_status: ["submit_for_review"]).to_sql)
    end
  end

  describe "attributes" do
    # it { should have_attr_accessor(:current_user_id) }
  end

  describe "callbacks" do
    # it { should callback(:set_defaults).after(:initialize) }
  end

  describe "nested attributes" do
    it { should accept_nested_attributes_for(:contentable) }
  end

   describe "enums" do
    it { should define_enum_for(:status).with_values(["draft", "publish", "disable"]) }
    it { should define_enum_for(:review_status).with_values(["pending", "submit_for_review", "approve", "rejected"]) }
  end

  describe "scopes" do
    it "returns published scope" do
      # expect(described_class.published.to_sql).to eq(described_class.publish.where("publish_date < ?", DateTime.current).to_sql)
    end

    it "returns blogs_content scope" do
      expect(described_class.blogs_content.to_sql).to eq(described_class.joins(:content_type).where(content_types: {identifier: 'blog'}).to_sql)
    end

    # it "returns filter_content scope" do
    #   categories = [your_categories]
    #   sub_categories = [your_sub_categories]
    #   content_types = [your_content_types]
    #   expect(described_class.filter_content(categories, sub_categories, content_types).to_sql).to eq(described_class.where(category: categories, sub_category: sub_categories, content_type: content_types).to_sql)
    # end

    it "returns in_review scope" do
      expect(described_class.in_review.to_sql).to eq(described_class.where(review_status: "submit_for_review").to_sql)
    end
  end
  
end