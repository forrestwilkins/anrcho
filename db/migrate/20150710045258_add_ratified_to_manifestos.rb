class AddRatifiedToManifestos < ActiveRecord::Migration
  def change
    add_column :manifestos, :ratified, :boolean
  end
end
