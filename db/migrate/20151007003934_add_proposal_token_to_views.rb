class AddProposalTokenToViews < ActiveRecord::Migration
  def change
    add_column :views, :proposal_token, :string
  end
end
