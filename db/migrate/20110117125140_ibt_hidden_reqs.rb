class IbtHiddenReqs < ActiveRecord::Migration
  def self.up
    create_table :ibt_hidden_reqs do |t|
      t.string   "category"
       t.string   "rack"
       t.string   "shelf"
       t.datetime "created_at"
       t.datetime "updated_at"
       t.integer  "respondent_id", :precision => 38, :scale => 0
       t.integer  "title_id",      :precision => 38, :scale => 0 
    end   
  end

  def self.down
    drop_table :ibt_hidden_reqs
  end
end
