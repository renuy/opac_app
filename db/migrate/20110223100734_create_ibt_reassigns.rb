class CreateIbtReassigns < ActiveRecord::Migration
  def self.up
    create_table :ibt_reassigns do |t|
      t.references :batch
      t.references :title
      t.references :ibtr
      t.integer :respondent_id
      t.integer :assigned_cnt
      t.string :state
      t.timestamps
    end
  end

  def self.down
    drop_table :ibt_reassigns
  end
end
