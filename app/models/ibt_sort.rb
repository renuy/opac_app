class IbtSort < ActiveRecord::Base
  belongs_to :consignment
  belongs_to :ibtr
  belongs_to :book, :class_name => 'Book', :foreign_key => 'book_no'

  validate :book_no, :presence => true
  validates_uniqueness_of :ibtr_id, :unless => :ibtr_not_found
  #validate :consignment_id, :presence => true, if :ibtr_id == 0
  
  before_save :set_details
  
  private
  def set_details
    self.ibtr_id = 0 if self.ibtr_id.nil? 
    self.consignment_id = 0 unless self.ibtr_id == 0
    #self.flg_no_isbn =  self.isbn.nil?  ? 'Y' :'N'
    self.flg_repeat_sort = new_record? ? 'N' : 'Y'
    self.flg_success = self.consignment_id.nil? ? 'N' : 'Y'
  end
  
  def ibtr_not_found
    if self.ibtr_id == 0 or self.ibtr_id.nil? 
      return true
    else
      return false
    end
  end
end
