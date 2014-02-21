class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :translation
  has_many :projects, dependent: :destroy
  has_many :user_languages
  has_many :languages, through: :user_languages
end
