class AddTokenToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :token, :string
    add_column :comments, :token, :string
    add_column :votes, :token, :string
  end
end
