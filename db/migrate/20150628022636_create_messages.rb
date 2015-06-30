class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :group_id
      t.text :body
      t.binary :salt
      t.timestamps null: false
    end
  end
end
