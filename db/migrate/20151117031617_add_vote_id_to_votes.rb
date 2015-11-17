class AddVoteIdToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :vote_id, :integer
  end
end
