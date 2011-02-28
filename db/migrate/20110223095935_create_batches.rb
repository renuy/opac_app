class CreateBatches < ActiveRecord::Migration
  def self.up
    create_table :batches do |t|
      t.string :batch_type
      t.string :assigned_to
      t.string :state
      t.integer :item_count
      t.integer :closed_count
      t.date :expires_on
      t.timestamps
    end
  end

  def self.down
    drop_table :batches
  end
end
