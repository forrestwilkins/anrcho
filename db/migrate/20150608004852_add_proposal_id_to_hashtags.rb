class AddProposalIdToHashtags < ActiveRecord::Migration
  def change
    add_column :hashtags, :proposal_id, :integer
    add_column :hashtags, :comment_id, :integer
    add_column :hashtags, :group_id, :integer
  end
end
