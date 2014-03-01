class Language < ActiveRecord::Base
  belongs_to :translation
  has_many :user_languages
  has_many :users, through: :user_languages

  validates :code, :name, presence: true
end
