class AddUniqueTokenToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :unique_token, :string
  end
end
