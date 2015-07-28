class AddBodyToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :body, :text
    add_column :proposals, :title, :text
    add_column :comments, :body, :text
  end
end
