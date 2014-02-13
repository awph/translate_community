class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :project_id
      t.string :key

      t.timestamps
    end
    add_index :items, :project_id

  end
end
