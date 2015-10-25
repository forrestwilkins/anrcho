class CreateDialogues < ActiveRecord::Migration
  def change
    create_table :dialogues do |t|
      t.string :sender
      t.string :receiver
      t.timestamps null: false
    end
  end
end
