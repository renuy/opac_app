class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.string :card_id
      t.integer :member_id
      t.string :member
      t.string :city
      t.integer :plan_id
      t.string :plan
      t.integer :inactive
    end
    
    add_index (:memberships, [:card_id, :member_id], :unique => true)
    add_index (:memberships, :card_id, :unique => true)
    add_index (:memberships, :member_id)
  end

  def self.down
    drop_table :memberships
  end
end
