class AlterIndexOnTitles < ActiveRecord::Migration
  def self.up
    remove_index :titles, :title
    add_index :titles, :title
  end

  def self.down
    remove_index :titles, :title
    add_index :titles, :title, :unique => true
  end
end
