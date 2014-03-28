class ChangeTranslationValueToText < ActiveRecord::Migration
  def up
    change_column :translations, :value, :text
  end

  def down
    change_column :translations, :value, :string
  end
end
