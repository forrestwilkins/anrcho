class AddManifestoIdToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :manifesto_id, :integer
  end
end
