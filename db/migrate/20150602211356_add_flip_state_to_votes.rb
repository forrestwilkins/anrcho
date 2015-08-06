class AddFlipStateToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :flip_state, :string
    add_column :votes, :comment_id, :integer
  end
end
