class AddRatifiedToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :ratified, :boolean
  end
end
