class AddIndexToHashtags < ActiveRecord::Migration
  def change
    add_column :hashtags, :index, :integer
  end
end
