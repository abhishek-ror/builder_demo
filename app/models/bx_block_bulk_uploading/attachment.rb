module BxBlockBulkUploading
  class Attachment < BxBlockBulkUploading::ApplicationRecord
    self.table_name = :attachments
    include Wisper::Publisher

    has_one_attached :attachment
    belongs_to :account, class_name: 'AccountBlock::Account'
  end
end
