class CreateIbtSorts < ActiveRecord::Migration
  def self.up
    create_table :ibt_sorts do |t|
      t.integer :book_no
      t.references :ibtr
      t.references :consignment
      t.string :isbn
      t.string :flg_no_isbn
      t.string :flg_repeat_sort	
      t.string :flg_success
      t.timestamps
    end
  end

  def self.down
    drop_table :ibt_sorts
  end
end
