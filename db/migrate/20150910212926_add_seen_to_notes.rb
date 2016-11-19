class AddSeenToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :seen, :boolean
  end
end
