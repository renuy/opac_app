class AddPonumberToIbtrs < ActiveRecord::Migration
  def self.up
    add_column :ibtrs, :po_no, :string
  end

  def self.down
    remove_column :ibtrs, :po_no
  end
end
