class AddUniqueTokenToComments < ActiveRecord::Migration
  def change
    add_column :comments, :unique_token, :string
  end
end
