class AddReadingLimitToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :reading_limit, :integer
  end

  def self.down
    remove_column :plans, :reading_limit
  end
end
