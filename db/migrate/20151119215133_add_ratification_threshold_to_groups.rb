class AddRatificationThresholdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :ratification_threshold, :integer
  end
end
