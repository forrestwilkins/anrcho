class RemoveNameFromGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :name
    remove_column :groups, :description
  end
end
