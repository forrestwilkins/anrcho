class AddVersionToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :version, :integer
  end
end
