class Item < ActiveRecord::Base
  belongs_to :project
  has_many :translations, dependent: :destroy, :order => "created_at DESC"

  validates :project_id, :key, presence: true

  def translations_sorted(language)
    sorted = translations.select { |translation| translation.language.id == language.id }
    sorted = sorted.sort_by { |translation| [translation.score, translation.created_at] }
    best = sorted.pop
    sorted = sorted.sort_by(&:created_at).reverse.unshift(best) unless best.nil?
    sorted
  end

  def first_translation
    translations.sort_by(&:created_at).reverse.pop
  end
end
