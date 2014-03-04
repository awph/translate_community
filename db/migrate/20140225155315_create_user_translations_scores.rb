class CreateUserTranslationsScores < ActiveRecord::Migration
  def change
    create_table :user_translations_scores do |t|
      t.integer :user_id
      t.integer :translation_id

      t.timestamps
    end
    add_index :user_translations_scores, :user_id
    add_index :user_translations_scores, :translation_id
  end
end
