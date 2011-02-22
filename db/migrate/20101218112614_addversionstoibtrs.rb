class Addversionstoibtrs < ActiveRecord::Migration
  def self.up
    Ibtr.create_versioned_table
  end

  def self.down
    Ibtr.drop_versioned_table
  end
end
