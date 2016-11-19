class AddProposalIdToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :proposal_id, :integer
  end
end
