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
  
  def self.get_ibtr_stats(params, start_d_s, end_d_s)
    created = params[:Created]
    start_date = Date.today.beginning_of_day
    end_date =  Date.today.end_of_day
    if created == 'Today'
      start_date = Date.today.beginning_of_day
      end_date =  Date.today.end_of_day
    elsif created == 'Range'
      start_date = start_d_s.to_time.beginning_of_day
      end_date =  end_d_s.to_time.beginning_of_day
    elsif created == 'On'
      start_date = start_d_s.to_time.beginning_of_day
      end_date =  start_d_s.to_time.end_of_day
    end
    if created == 'All'
      ibtr_stats = Ibtr.find(:all, :select => " decode(state, 'New', branch_id,'Received',branch_id,respondent_id) as branch_id , "+
      "sum(decode(state,'New',1,0)) as new_cnt,  "+
      "sum(decode(state,'Assigned',1,0)) as assigned_cnt,  "+
      "sum(decode(state,'Fulfilled',1,0)) as fulfilled_cnt,  "+
      "sum(decode(state,'Received',1,0)) as received_cnt, "+
      "sum(decode(state,'Declined',1,0)) as declined_cnt, "+
      "sum(decode(state,'Duplicate',1,0)) as duplicate_cnt, "+
      "sum(decode(state,'Cancelled',1,0)) as cancelled_cnt " , 
      :group => "decode(state, 'New', branch_id,'Received',branch_id,respondent_id)",
      :order => "branch_id")
    else 
      ibtr_stats = Ibtr.find(:all, :select => " decode(state, 'New', branch_id,'Received',branch_id,respondent_id) as branch_id , "+
      "sum(decode(state,'New',1,0)) as new_cnt,  "+
      "sum(decode(state,'Assigned',1,0)) as assigned_cnt,  "+
      "sum(decode(state,'Fulfilled',1,0)) as fulfilled_cnt,  "+
      "sum(decode(state,'Received',1,0)) as received_cnt, "+
      "sum(decode(state,'Declined',1,0)) as declined_cnt, "+
      "sum(decode(state,'Duplicate',1,0)) as duplicate_cnt, "+
      "sum(decode(state,'Cancelled',1,0)) as cancelled_cnt " , 
      :conditions => ["created_at >= ? and created_at <= ? ", start_date, end_date], 
      :group => "decode(state, 'New', branch_id,'Received',branch_id,respondent_id)",
      :order => "branch_id")
    end
    
  end
  
  def self.to_jit(ibtrStat)
    {
      'label' => ibtrStat.branch_id,
      'values' => [ibtrStat.new_cnt, ibtrStat.assigned_cnt, ibtrStat.fulfilled_cnt, ibtrStat.received_cnt ]
    }
  end    
end
