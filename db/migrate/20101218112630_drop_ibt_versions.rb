class DropIbtVersions < ActiveRecord::Migration
  def self.up
    drop_table :ibt_versions
  end

  def self.down
  end
end
