class AddDivisionToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :division, :string
  end

  def self.down
    remove_column :categories, :division
  end
end
