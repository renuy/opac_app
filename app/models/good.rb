class Good < ActiveRecord::Base
  include ActiveRecord::Transitions

  belongs_to :consignment, :counter_cache => true
  belongs_to :ibtr
  belongs_to :book, :class_name => 'Book', :foreign_key => 'book_no'
  belongs_to :title
  
  attr_accessor :event
  attr_accessible :book_no, :consignment_id, :state, :created_at, :ibtr_id, :title_id, :updated_at
  
  validates :book_no, :presence => true, :uniqueness => {:scope => :consignment_id}, :length => { :maximum => 30 }

  before_validation(:on => :create) { set_good_details }
  validate :is_an_open_consignment, :create
  validate :is_a_valid_book, :create
	after_create { fulfill_ibtr }
	after_destroy { undo_fulfill_ibtr }
	# after_update(:on => :update) { update_delivered_counter_cache }
  
  state_machine do
  	state :Pickedup
  	state :Delivered

    event :deliver do
      transitions :to => :Delivered, :from => :Pickedup
    end
	end

	def processEvent(event)
		case 
			when event.eql?(:deliver) then deliver!
		end
	end
  
  private
  def is_an_open_consignment
    errors.add(:consignment_id, ' is not valid') if self.consignment.nil?
    errors.add(:consignment_id, ' is not open') if self.consignment.state != 'Open'
  end
  
  def is_a_valid_book
    self.book = Book.find_by_book_no(book_no)
  end
  
  def set_good_details
    logger.debug('called set_good_details')
    self.consignment = Consignment.find(consignment_id)
    self.book = Book.find_by_book_no(book_no)
    unless book.nil?
      self.title_id = book.title_id
      self.ibtr = Ibtr.find_by_title_id_and_respondent_id_and_state(book.title_id, consignment.origin_id, 'Assigned')
      unless ibtr.nil?
        self.ibtr_id = ibtr.id
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
  
  # this is temp till the time transitions work
  def update_delivered_counter_cache
    self.consignment.decrement!(:goods_delivered_count) if self.state.to_sym == :Pickedup && self.state_was.to_sym == :Delivered
    self.consignment.increment!(:goods_delivered_count) if self.state.to_sym == :Delivered && self.state_was.to_sym == :Pickedup
  end
  
end
