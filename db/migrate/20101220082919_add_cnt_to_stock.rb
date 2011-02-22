class AddCntToStock < ActiveRecord::Migration
  def self.up
    add_column :stock, :in_store_cnt, :integer
    add_column :stock, :in_circulation_cnt, :integer
    add_column :stock, :unavailable_cnt, :integer
    add_column :stock, :total_cnt, :integer
  end

  def self.down
    remove_column :stock, :in_store_cnt
    remove_column :stock, :in_circulation_cnt
    remove_column :stock, :unavailable_cnt
    remove_column :stock, :total_cnt
  end
end
