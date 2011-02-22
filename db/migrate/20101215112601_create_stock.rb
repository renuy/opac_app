class CreateStock < ActiveRecord::Migration
  def self.up
    create_table :stock, :id => false do |t|
      t.integer :title_id
      t.integer :branch_id
      t.integer :total
      t.integer :in_store
      t.integer :in_circulation
      t.integer :unavailable
    end
  end

  def self.down
    drop_table :stock
  end
end
