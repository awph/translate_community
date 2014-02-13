class User < ActiveRecord::Base
  belongs_to :translation
  has_many :projects, dependent: :destroy
  has_many :user_languages
  has_many :languages, through: :user_languages
end
