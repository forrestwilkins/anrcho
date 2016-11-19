class AddVerifiedToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :verified, :boolean
  end
end
