class AddMootToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :moot, :boolean
  end
end
