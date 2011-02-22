class AddCouponToSignups < ActiveRecord::Migration
  def self.up
    add_column :signups, :coupon_amt, :float
    add_column :signups, :coupon_no, :string
    add_column :signups, :coupon_id, :integer
  end

  def self.down
    remove_column :signups, :coupon_id
    remove_column :signups, :coupon_no
    remove_column :signups, :coupon_amt
  end
end
