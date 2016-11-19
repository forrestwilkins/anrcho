class AddReceiverTokenToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :receiver_token, :string
  end
end
