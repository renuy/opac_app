class CreateTitles < ActiveRecord::Migration
  def self.up
    create_table :titles do |t|
      t.string :title, :null => false
      t.references :author
      t.references :publisher
      t.integer :yearofpublication
      t.integer :edition
      t.references :category
      t.string :isbn10
      t.string :isbn13
      t.integer :noofpages
      t.string :language

      t.timestamps
    end
    
    add_index :titles, :title, :unique => true
    add_index :titles, :author_id
    add_index :titles, :publisher_id
  end

  def self.down
    drop_table :titles
  end
end
