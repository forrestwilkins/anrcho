class AddViewLimitToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :view_limit, :integer
  end
end
