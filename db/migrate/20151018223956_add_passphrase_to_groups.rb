class AddPassphraseToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :passphrase, :string
  end
end
