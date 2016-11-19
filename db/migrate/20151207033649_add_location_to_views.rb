class AddLocationToViews < ActiveRecord::Migration
  def change
    add_column :views, :location, :text
    add_column :views, :latitude, :float
    add_column :views, :longitude, :float
  end
end
