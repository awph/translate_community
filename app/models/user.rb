class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :projects, dependent: :destroy
  has_many :user_languages
  has_many :languages, through: :user_languages
  has_many :translations, through: :user_translations_score

  validates :name, :email, presence: true
end
