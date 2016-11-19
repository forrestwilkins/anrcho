class AddGroupTokenToManifestos < ActiveRecord::Migration
  def change
    add_column :manifestos, :group_token, :string
  end
end
