class Language < ActiveRecord::Base
  has_many :user_languages
  has_many :users, through: :user_languages
  has_many :project_languages, dependent: :destroy
  has_many :projects, through: :project_languages

  validates :code, :name, presence: true
end
