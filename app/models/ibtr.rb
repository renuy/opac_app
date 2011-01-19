class Ibtr < ActiveRecord::Base
  include ActiveRecord::Transitions
  
  acts_as_versioned
  
  belongs_to :title
  belongs_to :membership
  
  belongs_to :branch
  belongs_to :respondent, :class_name => 'Branch', :foreign_key => 'respondent_id'
  #belongs_to :book, :foreign_key => 'book_number'
  attr_reader :event
  cattr_reader :per_page
  @@per_page = 10
  
  validate :is_valid_book_no

  state_machine do
    state :New # first one is the initial state
    state :Assigned
    state :Declined
    state :Fulfilled
    state :Dispatched
    state :Received
    state :Cancelled
    
    event :assign do
      transitions :to => :Assigned, :from => [:New, :Declined, :Cancelled]
    end
    event :decline do
      transitions :to => :Declined, :from => :Assigned
    end
    event :fulfill do
      transitions :to => :Fulfilled, :from => :Assigned
    end
    event :undo_fulfill do
      transitions :to => :Assigned, :from => :Fulfilled
    end
    event :dispatch do
      transitions :to => :Dispatched, :from => :Fulfilled
    end
    event :receive do
      transitions :to => :Received, :from => :Dispatched
    end
    event :cancel do
      transitions :to => :Cancelled, :from => [:New, :Assigned, :Declined]
    end
  end
  
  def processEvent(event)
    case 
    when event.eql?('assign') then assign
    when event.eql?('decline') then decline
    when event.eql?('fulfill') then fulfill
    when event.eql?('dispatch') then dispatch
    when event.eql?('receive') then receive
    when event.eql?('cancel') then cancel
    end
  end

  def self.search(params)
    unless (params[:card_id].nil?) then
      paginate :page => params[:page], :conditions => ['card_id = ?', params[:card_id]], :order => 'created_at, id DESC'
    else
      unless (params[:member_id].nil?) then
        paginate :page => params[:page], :conditions => ['member_id = ?', params[:member_id]], :order => 'created_at, id DESC'
      else
        unless (params[:state].nil?) then
          paginate :page => params[:page], :conditions => ['state = ?', params[:state]], :order => 'created_at, id DESC'
        else
          paginate :page => params[:page], :order => 'created_at, id DESC'
        end
      end
    end
  end  
  
  def self.complexSearch(params)
    clause = ''
    states = []

    states << params[:New] unless params[:New].nil?
    states << params[:Assigned] unless params[:Assigned].nil?
    states << params[:Cancelled] unless params[:Cancelled].nil?
    states << params[:Fulfilled] unless params[:Fulfilled].nil?
    states << params[:Declined] unless params[:Declined].nil?

    
    case 
      when params[:searchBy].eql?("card_id")
        clause << ' card_id = ?'
        values = params[:searchText]
      when params[:searchBy].eql?("member_id") 
        clause << ' member_id = ?'
        values = params[:searchText]
      when params[:searchBy].eql?("title_id") 
        clause << ' title_id = ?'
        values = params[:searchText]
      when params[:searchBy].eql?("branch_id") 
        clause << ' branch_id = ?'
        values = params[:branchVal]
      when params[:searchBy].eql?("respondent_id")
        clause << ' respondent_id = ?'
        values = params[:branchVal]
    end

    if !values.nil? && values.length > 0 then
      if states.length > 0 then
        paginate :page => params[:page], :conditions => [clause << ' AND state IN (?)', values, states], :order => 'created_at, id DESC'
      else
        paginate :page => params[:page], :conditions => [clause, values], :order => 'created_at, id DESC'
      end
    else
      paginate :page => params[:page], :conditions => ['state in (?)', states], :order => 'created_at, id DESC'
    end
  end  
  
  def is_valid_book_no
    if !book_no.nil? 
      
      if !Ibtr.book_not_fulfilled?(book_no)
        errors.add(book_no.to_s, " book already used to fulfill")
      end
      book = Book.find_by_book_no(book_no)
      if book.nil?
        errors.add(book_no.to_s, " invalid book number")
      end
      if book.title_id != title_id
        errors.add(book.title_id.to_s ," book title different from ibtr title")
      end
    end
  end
  
  def self.find_for_fulfill(book_no)
    book = Book.find_by_book_no(book_no)
    ibtrs = Ibtr.find(:all, :conditions => ['state in (?) AND title_id = ?', 'Assigned', book.title_id], :order => 'created_at')
    if !(ibtrs.nil? or ibtrs.size == 0) 
      #log error, do we check for new requests??? auto fulfill and not assigned
      return  ibtrs[0]
    else
      ibtr = Ibtr.new
      ibtr.set_error(book_no.to_s, "destination for book no #{book_no} not found")
      return ibtr
    end
    
  end
  
  def set_error(sym,msg)
    errors.add(sym.to_s, msg)
  end
  
  def set_fulfill(book_no)
      self.fulfill
      return update_attributes(:book_no => book_no, 
                            :state => self.current_state)
    
  end
  
  def self.book_not_fulfilled?(book_no)
    ibtrs = Ibtr.find_by_book_no(book_no)
    if ibtrs.nil?
      return true
    else
      return false
    end
  end
  
  def self.find_by_book_no(book_no)
    ibtrs = Ibtr.find(:all, :conditions => ['book_no = ? AND updated_at > ?', book_no, Time.now.utc - 1.day]  )
    if ibtrs.nil? or ibtrs.size == 0
      return nil
    else
      return ibtrs[0]
    end
  end
end
