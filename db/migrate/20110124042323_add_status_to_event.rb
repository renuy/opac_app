class AddStatusToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :status, :string
  end

  def self.down
    remove_column :events, :status
  end
end
