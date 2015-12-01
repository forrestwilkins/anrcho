class AddBodyToGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :description
    add_column :groups, :body, :text
  end
end
