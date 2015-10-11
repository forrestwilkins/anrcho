class AddGroupTokenToViews < ActiveRecord::Migration
  def change
    add_column :views, :group_token, :string
  end
end
