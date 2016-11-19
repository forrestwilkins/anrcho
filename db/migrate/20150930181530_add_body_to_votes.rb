class AddBodyToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :body, :string
  end
end
