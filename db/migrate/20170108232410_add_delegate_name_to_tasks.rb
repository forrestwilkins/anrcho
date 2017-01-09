class AddDelegateNameToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :delegate_name, :string
  end
end
