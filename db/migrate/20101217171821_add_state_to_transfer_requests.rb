class AddStateToTransferRequests < ActiveRecord::Migration
  def self.up
    add_column :transfer_requests, :state, :string
  end

  def self.down
    remove_column :transfer_requests, :state
  end
end
