class AddTokenToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :token, :string
  end
end
