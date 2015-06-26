class CreateMeetups < ActiveRecord::Migration
  def change
    create_table :meetups do |t|
      t.text :title
      t.text :body
      t.date :date
      t.text :location
      t.string :token
      t.timestamps null: false
    end
  end
end
