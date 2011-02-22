class DropTransferRequests < ActiveRecord::Migration
  def self.up
    drop_table :transfer_requests
  end

  def self.down
  end
end
