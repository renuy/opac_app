class Ibtr < ActiveRecord::Base
  include ActiveRecord::Transitions
  
  acts_as_versioned
  
  belongs_to :title
  belongs_to :membership
  
  belongs_to :branch
  belongs_to :respondent, :class_name => 'Branch', :foreign_key => 'respondent_id'
  attr_reader :event
  cattr_reader :per_page
  @@per_page = 10

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
  
  
  # class method to fulfill a matching ibtr record
  def self.fulfill(book_no)
    book = Book.find_by_book_no(book_no)

    unless book.nil?
      ibtr = Ibtr.order("created_at").find_by_title_id_and_state(book.title_id, 'Assigned')
      
      unless ibtr.nil?
        ibtr.book_no = book_no
        ibtr.fulfill!
        ibtr
      end
    end
  end
  
end
