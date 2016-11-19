class AddVoteIdToHashtags < ActiveRecord::Migration
  def change
    add_column :hashtags, :vote_id, :integer
  end
end
