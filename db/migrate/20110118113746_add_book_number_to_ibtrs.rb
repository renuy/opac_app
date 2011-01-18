class AddBookNumberToIbtrs < ActiveRecord::Migration
  def self.up
      add_column :ibtrs, :book_no, :string
  end

  def self.down
    remove_column :ibtrs, :book_no
  end
end
