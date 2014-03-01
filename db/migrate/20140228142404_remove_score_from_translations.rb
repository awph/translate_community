class RemoveScoreFromTranslations < ActiveRecord::Migration
  def change
    remove_column :translations, :score, :integer
  end
end
