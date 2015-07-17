class AddMiscDataToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :misc_data, :string
  end
end
