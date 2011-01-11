class CreateConsignments < ActiveRecord::Migration
  def self.up
    create_table :consignments do |t|
      t.string :consignor
      t.string :consignee
      t.integer :origin_id
      t.integer :destination_id
      t.string :waybill_no
      
      t.string :origin_address
      t.string :destination_address

      t.integer :goods_count
      t.integer :goods_delivered_count

      t.string :state
      t.timestamp :pickup_date
      t.timestamp :delivery_date

      t.timestamps
    end
  end

  def self.down
    drop_table :consignments
  end
end
