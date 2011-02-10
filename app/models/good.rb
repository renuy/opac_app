class Good < ActiveRecord::Base
  include ActiveRecord::Transitions

  belongs_to :consignment, :counter_cache => true
  belongs_to :ibtr
  belongs_to :book, :class_name => 'Book', :foreign_key => 'book_no'
  belongs_to :title
  
  attr_accessible :book_no, :consignment_id, :ibtr_id
  
  validates :book_no, :presence => true, :uniqueness => {:scope => :consignment_id}, :length => { :maximum => 30 }
  
  validate :is_a_valid_consignment

	state_machine do
  	state :Pickedup
  	state :Delivered

		event :deliver do
			transitions :to => :Delivered, :from => :Pickedup
		end
	end

	before_validation :set_good_details
	after_create { fulfill_ibtr }
	after_destroy { undo_fulfill_ibtr }

	def processEvent(event)
		case 
			when event.eql?("deliver") then deliver
		end
	end

  
	def is_a_valid_consignment 
	  if consignment.state != 'Open'
	    errors.add(:consignment_id, " cannot accept goods as it is #{consignment.state}")
    end
    
    if book.nil?
      errors.add(:book_no, ' not found in stock')
	  end
  end
  
  private
  def set_good_details
    self.consignment = Consignment.find(consignment_id) 
    self.book = Book.find_by_book_no(book_no)
    unless book.nil?
      self.title_id = book.title_id
      if self.ibtr_id.nil?
        self.ibtr = Ibtr.find_by_title_id_and_respondent_id_and_state(book.title_id, consignment.origin_id, ['Assigned','POPlaced'])
        unless ibtr.nil?
          self.ibtr_id = ibtr.id
        end
      end
    end
  end
  
  def fulfill_ibtr
    unless ibtr.nil?
      ibtr.book_no = book_no
      ibtr.fulfill!
    end
  end
  
  def undo_fulfill_ibtr
    unless ibtr_id.nil?
      ibtr.book_no = nil
      ibtr.undo_fulfill! 
    end
  end
  
end