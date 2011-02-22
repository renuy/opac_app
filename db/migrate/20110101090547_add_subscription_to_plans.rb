class AddSubscriptionToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :subscription, :boolean
  end

  def self.down
    remove_column :plans, :subscription
  end
end
