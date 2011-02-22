class CreateIbtrs < ActiveRecord::Migration
  def self.up
    create_table :ibtrs do |t|
      t.references :title

      t.integer :member_id
      t.string  :card_id
      t.integer :branch_id
      t.integer :rns_id
      
      t.string :state
      
      t.timestamps
    end
  end

  def self.down
    drop_table :ibtrs
  end
end
