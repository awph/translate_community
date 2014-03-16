class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :projects, dependent: :destroy
  has_many :user_languages
  has_many :languages, through: :user_languages
  has_many :user_translations_scores
  has_many :translations, through: :user_translations_scores

  validates :name, :email, presence: true

  def reputation
    rep = 1
    translations = Translation.where(user_id: id)
    translations.each do |translation|
      rep += translation.score
    end
    rep
  end

end
