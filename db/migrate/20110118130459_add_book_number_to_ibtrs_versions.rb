class AddBookNumberToIbtrsVersions < ActiveRecord::Migration
  def self.up
      add_column :ibtr_versions, :book_no, :string
  end

  def self.down
    remove_column :ibtr_versions, :book_no
  end
end
