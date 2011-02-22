class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.string :book_no
      t.string :shelf_location
      t.integer :branch_id
      t.integer :catalogued_branch_id
      t.string :state
      t.integer :title_id

      t.timestamps
    end
    
    add_index :books, :book_no, :unique => true
  end

  def self.down
    drop_table :books
  end
end
