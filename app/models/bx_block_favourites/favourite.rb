module BxBlockFavourites
  class Favourite < BxBlockFavourites::ApplicationRecord
    self.table_name = :favourites

    belongs_to :favouriteable, polymorphic: true
  	belongs_to :account, class_name: 'AccountBlock::Account', optional: true, foreign_key: :account_id
  end
end
