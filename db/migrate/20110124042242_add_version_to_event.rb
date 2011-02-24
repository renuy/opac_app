class AddVersionToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :version, :integer
  end

  def self.down
    remove_column :events, :version
  end
end
