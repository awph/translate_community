class Item < ActiveRecord::Base
  belongs_to :project
  has_many :translations, dependent: :destroy

  validates :project_id, :key, presence: true
end
