class CreateTranslations < ActiveRecord::Migration
  def change
    create_table :translations do |t|
      t.integer :item_id
      t.integer :language_id
      t.integer :user_id
      t.string :value
      t.integer :score

      t.timestamps
    end
    add_index :translations, :item_id
    add_index :translations, :language_id
    add_index :translations, :user_id

  end
end
