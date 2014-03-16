class CreateProjectLanguages < ActiveRecord::Migration
  def change
    create_table :project_languages do |t|
      t.integer :project_id
      t.integer :language_id

      t.timestamps
    end
    add_index :project_languages, :project_id
    add_index :project_languages, :language_id
  end
end
