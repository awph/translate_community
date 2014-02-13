class Translation < ActiveRecord::Base
  has_one :user
  has_one :language
  belongs_to :item
end
