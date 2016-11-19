class AddGroupTokenToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :group_token, :string
    add_column :banners, :group_token, :string
    add_column :messages, :group_token, :string
  end
end
