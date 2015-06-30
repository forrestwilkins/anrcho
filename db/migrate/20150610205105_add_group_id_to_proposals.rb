class AddGroupIdToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :group_id, :integer
  end
end
