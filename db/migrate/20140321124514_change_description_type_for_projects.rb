class ChangeDescriptionTypeForProjects < ActiveRecord::Migration
  def up
    change_column :projects, :description, :text
  end

  def down
    change_column :projects, :description, :string
  end
end
