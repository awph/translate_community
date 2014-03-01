class AddUpToUserTranslationsScores < ActiveRecord::Migration
  def change
    add_column :user_translations_scores, :up, :boolean
  end
end
