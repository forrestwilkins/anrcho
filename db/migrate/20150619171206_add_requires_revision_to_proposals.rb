class AddRequiresRevisionToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :requires_revision, :boolean
  end
end
