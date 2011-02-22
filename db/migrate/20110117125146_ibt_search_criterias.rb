class IbtSearchCriterias < ActiveRecord::Migration
  def self.up
    create_table :ibt_search_criterias do |t|
       t.integer   "respondent_id",              :precision => 38, :scale => 0
       t.timestamp "time_basis"
       t.datetime  "created_at"
       t.datetime  "updated_at"
     end    
  end

  def self.down
    drop_table :ibt_search_criterias
  end
end
