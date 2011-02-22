class CreateTransferRequests < ActiveRecord::Migration
  def self.up
    create_table :transfer_requests do |t|
      t.references :title

      t.integer :member_id
      t.string  :card_id
      t.integer :branch_id
      t.integer :rns_id
      t.timestamps
    end
  end

  def self.down
    drop_table :transfer_requests
  end
end
