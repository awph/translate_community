class AddUniqueIndexOnScores < ActiveRecord::Migration
  def change
    add_index "user_translations_scores", ["user_id", "translation_id"], :unique => true
  end
end
