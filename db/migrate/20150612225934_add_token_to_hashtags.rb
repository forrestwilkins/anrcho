class AddTokenToHashtags < ActiveRecord::Migration
  def change
    add_column :hashtags, :token, :string
  end
end
