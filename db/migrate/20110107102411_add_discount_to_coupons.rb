class AddDiscountToCoupons < ActiveRecord::Migration
  def self.up
    add_column :coupons, :discount, :float
  end

  def self.down
    remove_column :coupons, :discount
  end
end
