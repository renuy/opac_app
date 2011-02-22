class AddVersionedIbt < ActiveRecord::Migration
  def self.up
    Ibt.create_versioned_table
  end

  def self.down
    Ibt.drop_versioned_table
  end
end
