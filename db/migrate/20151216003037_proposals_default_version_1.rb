class ProposalsDefaultVersion1 < ActiveRecord::Migration
  def change
    change_column_default :proposals, :version, 1
  end
end
