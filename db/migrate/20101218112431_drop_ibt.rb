class DropIbt < ActiveRecord::Migration
  def self.up
    drop_table :ibts
  end

  def self.down
  end
end
