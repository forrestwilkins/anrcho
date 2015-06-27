class CreateManifestos < ActiveRecord::Migration
  def change
    create_table :manifestos do |t|
      t.text :title
      t.text :body
      t.timestamps null: false
    end
  end
end
