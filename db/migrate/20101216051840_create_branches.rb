class CreateBranches < ActiveRecord::Migration
  def self.up
    create_table :branches do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :phone
      t.string :email
      t.string :is_a
      t.integer :parent_id
      t.string :parent_name

      t.timestamps
    end
  end

  def self.down
    drop_table :branches
  end
end
