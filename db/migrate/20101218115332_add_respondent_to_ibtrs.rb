class AddRespondentToIbtrs < ActiveRecord::Migration
  def self.up
    add_column :ibtrs, :respondent_id, :string
    add_column :ibtr_versions, :respondent_id, :string
  end

  def self.down
    remove_column :ibtrs, :respondent_id
    remove_column :ibtr_versions, :respondent_id, :string
  end
end
