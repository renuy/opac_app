class AddReasonToIbtrs < ActiveRecord::Migration
  def self.up
    add_column :ibtrs, :reason_id, :integer
    add_column :ibtrs, :comment, :string
  end

  def self.down
    remove_column :ibtrs, :comment
    remove_column :ibtrs, :reason_id
  end
end
