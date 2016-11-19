class AddPassProtectedToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :pass_protected, :boolean
  end
end
