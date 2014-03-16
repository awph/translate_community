class Project < ActiveRecord::Base
  belongs_to :user
  has_many :items, dependent: :destroy
  has_many :project_languages, dependent: :destroy
  has_many :languages, through: :project_languages

  validates :user_id, :name, :description, presence: true
end
