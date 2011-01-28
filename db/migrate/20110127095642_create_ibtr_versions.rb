class CreateIbtrVersions < ActiveRecord::Migration
  def self.up
    create_table :ibtr_versions do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :ibtr_versions
  end
end
