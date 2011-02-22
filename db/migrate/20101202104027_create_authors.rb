class CreateAuthors < ActiveRecord::Migration
  def self.up
    create_table :authors do |t|
      t.string :name
      t.string :firstname
      t.string :middlename
      t.string :lastname
      t.timestamps
    end
    
    add_index :authors, :name
  end

  def self.down
    drop_table :authors
  end
end
