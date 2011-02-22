class CreateStockitems < ActiveRecord::Migration
  def self.up
    create_table(:stockitems) do |t|
      t.references :title
      t.references :author
      t.references :category
      t.references :publisher
      
      t.string  :title_name
      t.string  :isbn
      t.decimal :price
      t.string  :language
      t.string  :edition
      t.string  :pubyear
      t.integer :pages
      t.string  :binding
    end
    
    add_index :stockitems, :title_id, :unique => true
  end

  def self.down
    drop_table :stockitems
  end
end
