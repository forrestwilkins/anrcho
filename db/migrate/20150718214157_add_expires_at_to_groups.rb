class AddExpiresAtToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :expires_at, :datetime
  end
end
