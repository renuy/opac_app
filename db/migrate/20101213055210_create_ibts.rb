class CreateIbts < ActiveRecord::Migration
  def self.up
    create_table :ibts do |t|
      t.references :transfer_request      
      t.string :state
      t.string :created_for
      t.string :assigned_to

      t.integer :book_id
      
      t.integer :alt1_title_id
      t.integer :alt2_title_id
      t.integer :alt3_title_id
      t.integer :alt4_title_id
      t.integer :alt5_title_id
      t.integer :alt6_title_id
      t.integer :alt7_title_id
      t.integer :alt8_title_id
      t.integer :alt9_title_id

      t.timestamps
    end
  end

  def self.down
    drop_table :ibts
  end
end
