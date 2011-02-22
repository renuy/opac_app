class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.string :name
      t.float :security_deposit
      t.float :registration_fee
      t.float :reading_fee
      t.float :magazine_fee
      t.integer :num_books
      t.integer :num_magazines

      t.timestamps
    end
  end

  def self.down
    drop_table :plans
  end
end
