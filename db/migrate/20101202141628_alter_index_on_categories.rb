class AlterIndexOnCategories < ActiveRecord::Migration
  def self.up
    remove_index :categories, :name
    add_index :categories, [:name, :type], :unique => true
  end

  def self.down
    remove_index :categories, [:name, :type]
    add_index :categories, :name, :unique => true
  end
end
