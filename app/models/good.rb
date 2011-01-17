class Good < ActiveRecord::Base
  include ActiveRecord::Transitions

  belongs_to :consignment, :counter_cache => true
  belongs_to :ibtr
  belongs_to :book, :class_name => 'Book', :foreign_key => 'book_no'
  belongs_to :title
  
  attr_accessible :book_no, :consignment_id
  
  validates :book_no, :presence => true, :uniqueness => {:scope => :consignment_id}, :length => { :maximum => 30 }
  
  validate :is_a_valid_ibtr_and_consignment

	state_machine do
  	state :Pickedup
  	state :Delivered

		event :deliver do
			transitions :to => :Delivered, :from => :Pickedup
		end
	end
	
	before_validation :set_good_details
	after_create { |record| record.ibtr.fulfill! }
	after_destroy { |record| Ibtr.find(record.ibtr_id).undo_fulfill! }
	
	def processEvent(event)
		case 
			when event.eql?("deliver") then deliver
		end
	end
	
  
	def is_a_valid_ibtr_and_consignment 
	  if consignment.state != 'Open'
	    errors.add(:consignment_id, " cannot accept goods as it is #{consignment.state}")
    end
    
    if book.nil?
      errors.add(:book_no, ' not found in stock')
    else
  	  if ibtr.nil?
  	    errors.add(:book_no, " (title #{book.title_id}) is not assigned to this branch or already fulfilled")
  	  end
	  end
  end
  
  private
  def set_good_details
    self.consignment = Consignment.find(consignment_id) 
    self.book = Book.find_by_book_no(book_no)
    unless book.nil?
      self.ibtr = Ibtr.find_by_title_id_and_respondent_id_and_state(book.title_id, consignment.origin_id, 'Assigned')
      unless ibtr.nil?
        self.title_id = book.title_id
        self.ibtr_id = ibtr.id
      end
    end
  end
end
