class AddUniqueTokenToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :unique_token, :string
  end
end
