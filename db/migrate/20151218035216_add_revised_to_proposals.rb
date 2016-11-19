class AddRevisedToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :revised, :boolean
  end
end
