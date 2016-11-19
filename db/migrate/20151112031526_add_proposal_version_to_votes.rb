class AddProposalVersionToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :proposal_version, :integer
  end
end
