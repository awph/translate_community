class Translation < ActiveRecord::Base
  has_many :user_translations_scores
  has_many :users, through: :user_translations_scores
  belongs_to :user
  belongs_to :language
  belongs_to :item

  validates :item_id, :language_id, :user_id, :value, presence: true

  def score
    score = 0
    UserTranslationsScore.where(translation_id: id).each do |vote|
      reputation = User.find(vote.user_id).reputation
      reputation *= -1 unless vote.up
      score += reputation
    end
    score
  end

  def vote_up(current_user)
    vote(current_user, TRUE)
  end

  def vote_down(current_user)
    vote(current_user, FALSE)
  end

  private

  def vote(current_user, up)
    user_translations_score = UserTranslationsScore.where(user_id: current_user.id, translation_id: id).take
    translation = Translation.where(id: id, user_id: current_user.id).take
    if translation.nil?
      # error cant up my translation
    else
      if user_translations_score
        user_translations_score.up = up
        user_translations_score.save
      else
        UserTranslationsScore.create(user_id: current_user.id, translation_id: id, up: up)
      end
    end
  end

end
