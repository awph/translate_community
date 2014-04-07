class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable
  has_many :projects, dependent: :destroy
  has_many :user_languages
  has_many :languages, through: :user_languages
  has_many :user_translations_scores
  has_many :translations, through: :user_translations_scores
  
  validates :name, uniqueness: true, presence: true

  accepts_nested_attributes_for :user_languages

  @@reputation_ratio = 10

  def reputation
    rep = 0
    translations = Translation.where(user_id: id)
    translations.each do |translation|
      rep += translation.score
    end
    rep /= @@reputation_ratio
    rep += 1
  end

end
