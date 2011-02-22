class CreatePublishers < ActiveRecord::Migration
  def self.up
    create_table :publishers do |t|
      t.string :name
      t.string :country
      t.timestamps
    end
    
    add_index :publishers, :name
  end

  def self.down
    drop_table :publishers
  end
end
