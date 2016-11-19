class AddRevisedActionToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :revised_action, :string
  end
end
