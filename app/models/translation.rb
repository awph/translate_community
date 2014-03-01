class Translation < ActiveRecord::Base
  has_many :users, through: :user_translations_score
  has_one :user
  has_one :language
  belongs_to :item

  validates :item_id, :language_id, :user_id, :value, presence: true

  def score
    score = 0
    UserTranslationsScore.where(translation_id: id).each do |vote|
      reputation = 1#User.find(vote.user_id).reputation
      reputation *= -1 unless vote.up
      score += reputation
    end
    score
  end

  def vote_up
    vote(TRUE)
  end

  def vote_down
    vote(FALSE)
  end

  private

  def vote(is_up)
    UserTranslationsScore.create(user_id: 1, translation_id: id, up: is_up)
  end

end
