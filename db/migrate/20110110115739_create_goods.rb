class CreateGoods < ActiveRecord::Migration
  def self.up
    create_table :goods do |t|
      t.string :book_no
      t.references :title
      t.references :ibtr
      t.references :consignment
      t.string :state

      t.timestamps
    end
  end

  def self.down
    drop_table :goods
  end
end
