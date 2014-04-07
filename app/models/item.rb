class Item < ActiveRecord::Base
  belongs_to :project
  has_many :translations, dependent: :destroy, :order => "created_at DESC"

  validates :project_id, :key, presence: true

  def translations_sorted
    sorted = translations.sort_by { |translation| [translation.score, translation.created_at] }
    best = sorted.pop
    sorted = sorted.sort_by(&:created_at).reverse.unshift(best) unless best.nil?
    sorted
  end
end
