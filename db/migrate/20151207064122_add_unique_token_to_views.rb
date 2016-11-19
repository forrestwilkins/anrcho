class AddUniqueTokenToViews < ActiveRecord::Migration
  def change
    add_column :views, :unique_token, :string
  end
end
