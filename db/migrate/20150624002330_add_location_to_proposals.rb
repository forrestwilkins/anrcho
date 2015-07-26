class AddLocationToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :location, :text
    add_column :proposals, :latitude, :float
    add_column :proposals, :longitude, :float
    
    add_column :comments, :location, :text
    add_column :comments, :latitude, :float
    add_column :comments, :longitude, :float
  end
end
