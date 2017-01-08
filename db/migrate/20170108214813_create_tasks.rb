class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :token
      t.string :group_token
      t.integer :group_id
      t.string :title
      t.text :description
      t.datetime :expires_at
      t.timestamps null: false
    end
  end
end
