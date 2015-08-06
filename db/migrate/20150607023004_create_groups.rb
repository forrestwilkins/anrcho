class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.text :name
      t.text :description
      t.string :token
      t.timestamps null: false
    end
  end
end
