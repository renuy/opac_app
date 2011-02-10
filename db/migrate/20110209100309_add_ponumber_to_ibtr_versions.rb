class AddPonumberToIbtrVersions < ActiveRecord::Migration
  def self.up
    add_column :ibtr_versions, :po_no, :string
  end

  def self.down
    remove_column :ibtr_versions, :po_no
  end
end
