class DropIncolsFromStock < ActiveRecord::Migration
  def self.up
    remove_column :stock, :in_store
    remove_column :stock, :in_circulation
    remove_column :stock, :unavailable
    remove_column :stock, :total
  end

  def self.down
    add_column :stock, :in_store, :integer
    add_column :stock, :in_circulation, :integer
    add_column :stock, :unavailable, :integer
    add_column :stock, :total, :integer
  end
end
