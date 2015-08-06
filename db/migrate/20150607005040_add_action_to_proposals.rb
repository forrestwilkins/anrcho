class AddActionToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :action, :string
  end
end
