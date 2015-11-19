class AddVoteIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :vote_id, :integer
  end
end
