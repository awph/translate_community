class Item < ActiveRecord::Base
  belongs_to :project
  has_many :translations, dependent: :destroy
end
