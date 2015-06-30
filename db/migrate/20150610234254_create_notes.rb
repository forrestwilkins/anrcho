class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :message
      t.string :action
      t.integer :item_id
      t.string :item_token
      t.string :sender_token
      t.string :receiver_token
      t.timestamps null: false
    end
  end
end
