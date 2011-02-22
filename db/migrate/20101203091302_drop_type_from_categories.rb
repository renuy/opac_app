class DropTypeFromCategories < ActiveRecord::Migration
  def self.up
    remove_index :categories, [:name, :type]
    remove_column :categories, :type
    add_index :categories, [:name, :division], :unique => true
  end

  def self.down
  end
end
