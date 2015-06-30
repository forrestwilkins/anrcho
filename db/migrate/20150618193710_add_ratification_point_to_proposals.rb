class AddRatificationPointToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :ratification_point, :integer
  end
end
