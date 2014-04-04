class Project < ActiveRecord::Base
  belongs_to :user
  has_many :items, dependent: :destroy
  has_many :project_languages, dependent: :destroy
  has_many :languages, through: :project_languages

  validates :user_id, :name, :description, presence: true

  def translations
    translations = Hash.new
    items.each do |item|
      key = item.key
      item.translations.each do |translation|
        code = translation.language.code
        translations[code] = Hash.new if translations[code].nil?
        translations[code][key] = Hash.new if translations[code][key].nil?
        score = translations[code][key][:score]
        if score.nil? or score < translation.score
          translations[code][key][:score] = translation.score
          translations[code][key][:value] = translation.value
        end
      end
    end
    translations
  end

  def progression(language)
    if items.count == 0
      return 0
    end
    translated_quantity = 0.0
    items.each do |item|
      item.translations.each do |translation|
        if translation.language.id == language.id
          translated_quantity += 1
          break
        end
      end
    end
    translated_quantity / items.count
  end

end
