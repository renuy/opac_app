class CreateMemberReversals < ActiveRecord::Migration
  def self.up
    create_table :member_reversals do |t|
      t.string :membership_no
      t.string :nm_reversal

      t.timestamps
    end
  end

  def self.down
    drop_table :member_reversals
  end
end
