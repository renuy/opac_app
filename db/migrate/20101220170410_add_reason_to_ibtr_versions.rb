class AddReasonToIbtrVersions < ActiveRecord::Migration
  def self.up
    add_column :ibtr_versions, :reason_id, :integer
    add_column :ibtr_versions, :comment, :string
  end

  def self.down
    remove_column :ibtr_versions, :comment
    remove_column :ibtr_versions, :reason_id
  end
end
