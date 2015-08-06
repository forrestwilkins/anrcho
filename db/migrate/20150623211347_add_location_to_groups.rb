class AddLocationToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :location, :text
    add_column :groups, :latitude, :float
    add_column :groups, :longitude, :float
  end
end
