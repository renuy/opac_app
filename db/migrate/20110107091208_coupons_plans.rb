  class CouponsPlans < ActiveRecord::Migration
  def self.up
    create_table :coupons_plans, :id => false do |t|
      t.integer :coupon_id
      t.integer :plan_id

      t.timestamps
    end    
  end

  def self.down
    drop_table :coupons_plans
  end
end
