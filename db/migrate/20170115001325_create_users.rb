class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :token
      t.string :passphrase
      t.binary :salt
      t.timestamps null: false
    end
  end
end
