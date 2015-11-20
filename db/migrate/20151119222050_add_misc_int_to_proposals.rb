class AddMiscIntToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :misc_int, :integer
    add_column :proposals, :misc_string, :string
  end
end
