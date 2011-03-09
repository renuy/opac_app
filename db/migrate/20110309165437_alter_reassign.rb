class AlterReassign < ActiveRecord::Migration
  def self.up
    add_column :ibt_reassigns, :good_id, :integer
  end

  def self.down
    remove_column :ibt_reassigns, :good_id
  end
end
