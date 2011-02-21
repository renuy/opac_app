class Ibtr < ActiveRecord::Base
  include ActiveRecord::Transitions
  
  acts_as_versioned
  
  belongs_to :title
  belongs_to :membership
  belongs_to :book,  :foreign_key => 'book_no'
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
    state :POPlaced
    state :Dispatched
    state :Received
    state :Cancelled
    state :Delivered
    state :Timedout
    
    event :assign do
      transitions :to => :Assigned, :from => [:New, :Declined, :Cancelled]
    end
    event :decline do
      transitions :to => :Declined, :from => :Assigned
    end
    event :poplace do
      transitions :to => :POPlaced, :from => :Assigned
    end
    event :fulfill do
      transitions :to => :Fulfilled, :from => [:Assigned, :POPlaced]
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
    event :deliver do
      transitions :to => :Delivered, :from => :Received
    end
    event :timeout do
      transitions :to => :Timedout, :from => :Received
    end

  end
  
  def processEvent(event)
    case 
    when event.eql?('assign') then assign
    when event.eql?('decline') then decline
    when event.eql?('poplace') then poplace
    when event.eql?('fulfill') then fulfill
    when event.eql?('dispatch') then dispatch
    when event.eql?('receive') then receive
    when event.eql?('cancel') then cancel
    when envent.eql?('deliver') then deliver
    when envent.eql?('timeout') then timeout
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
  
  def self.curr_view_qry( created, start_date, end_date)
    ibtr_stats = nil
    if created == 'All'
      ibtr_stats = Ibtr.find(:all, :select => " branch_id , "+
      "sum(decode(state,'New',1,0)) as new_cnt,  "+
      "sum(decode(state,'Assigned',1,0)) as assigned_cnt,  "+
      "sum(decode(state,'POPlaced',1,0)) as poplaced_cnt,  "+
      "sum(decode(state,'Fulfilled',1,0)) as fulfilled_cnt,  "+
      "sum(decode(state,'Received',1,0)) as received_cnt, "+
      "sum(decode(state,'Declined',1,0)) as declined_cnt, "+
      "sum(decode(state,'Dispatched',1,0)) as dispatched_cnt, "+
      "sum(decode(state,'Cancelled',1,0)) as cancelled_cnt, " +
      "count(state) as total_cnt, " +
      "sum(decode(state,'Delivered',1,0)) as delivered_cnt, " +
      "sum(decode(state,'Timedout',1,0)) as timedout_cnt, " +
      "sum(decode(state,'Duplicate',1,0)) as duplicate_cnt, " + 
	  "sum(case when respondent_id = 951 and state in ('Assigned') then 1 else 0 end) as poassigned_cnt" ,
      :group => " branch_id ",
      :order => "branch_id")
    else 
      ibtr_stats = Ibtr.find(:all, :select => " branch_id , "+
      "sum(decode(state,'New',1,0)) as new_cnt,  "+
      "sum(decode(state,'Assigned',1,0)) as assigned_cnt,  "+
      "sum(decode(state,'POPlaced',1,0)) as poplaced_cnt,  "+
      "sum(decode(state,'Fulfilled',1,0)) as fulfilled_cnt,  "+
      "sum(decode(state,'Received',1,0)) as received_cnt, "+
      "sum(decode(state,'Declined',1,0)) as declined_cnt, "+
      "sum(decode(state,'Dispatched',1,0)) as dispatched_cnt, "+
      "sum(decode(state,'Cancelled',1,0)) as cancelled_cnt , " +
      "count(state) as total_cnt, " +
      "sum(decode(state,'Delivered',1,0)) as delivered_cnt, " +
      "sum(decode(state,'Timedout',1,0)) as timedout_cnt, " +
      "sum(decode(state,'Duplicate',1,0)) as duplicate_cnt, " +
	  "sum(case when respondent_id = 951 and state in ('Assigned') then 1 else 0 end) as poassigned_cnt" ,
      :conditions => ["created_at >= ? and created_at <= ? ", start_date, end_date], 
      :group => "  branch_id ",
      :order => "branch_id")
    end
    
    return ibtr_stats
  end

  def self.respondent_view_qry( created, start_date, end_date)
    ibtr_stats = nil  
    if created == 'All'
      ibtr_stats = Ibtr.find(:all, :select => "  respondent_id , "+
      "count(respondent_id) as total_cnt, "+
      "sum(decode(state,'Assigned',1,0)) as assigned_cnt,  "+
      "sum(decode(state,'POPlaced',1,0)) as poplaced_cnt,  "+
      "sum(decode(state,'Fulfilled',1,0)) as fulfilled_cnt,  "+
      "sum(decode(state,'Declined',1,0)) as declined_cnt, "+
      "sum(decode(state,'Dispatched',1,0)) as dispatched_cnt, " +
      "sum(decode(state,'Received',1,0)) as received_cnt, "+  
      "sum(decode(state,'Duplicate',1,0)) as duplicate_cnt ",
      :conditions => ["respondent_id is not null"],
      :group => " respondent_id ",
      :order => "to_number(respondent_id)")
    else 
      ibtr_stats = Ibtr.find(:all, :select => " respondent_id  , "+
      "count(respondent_id) as total_cnt, "+
      "sum(decode(state,'Assigned',1,0)) as assigned_cnt,  "+
      "sum(decode(state,'POPlaced',1,0)) as poplaced_cnt,  "+
      "sum(decode(state,'Fulfilled',1,0)) as fulfilled_cnt,  "+
      "sum(decode(state,'Declined',1,0)) as declined_cnt, "+
      "sum(decode(state,'Dispatched',1,0)) as dispatched_cnt, " +
      "sum(decode(state,'Received',1,0)) as received_cnt, "+  
      "sum(decode(state,'Duplicate',1,0)) as duplicate_cnt ",
      :conditions => ["respondent_id is not null and created_at >= ? and created_at <= ? ", start_date, end_date], 
      :group => " respondent_id ",
      :order => "to_number(respondent_id)")
    end
    ibtr_stats
  end
  
  def self.get_ibtr_stats(params, start_d_s, end_d_s)
    created = params[:Created]
    start_date = Time.zone.today.beginning_of_day
    end_date =  Time.zone.today.end_of_day
    if created == 'Today'
      start_date = Time.zone.today.beginning_of_day
      end_date =  Time.zone.today.end_of_day
    elsif created == 'Range'
      start_date = start_d_s.to_time.beginning_of_day
      end_date =  end_d_s.to_time.beginning_of_day
    elsif created == 'On'
      start_date = start_d_s.to_time.beginning_of_day
      end_date =  start_d_s.to_time.end_of_day
    end
    ibtr_stats = nil
    case 
      when params[:report].eql?('respondent_view') then 
        ibtr_stats = Ibtr.respondent_view_qry( created, start_date, end_date)
        
      when params[:report].eql?('curr_state') then 
        ibtr_stats = Ibtr.curr_view_qry( created, start_date, end_date)
    end
    
    return ibtr_stats
  end
  
  def self.query(params, start_d_s, end_d_s)
    created = params[:Created]
    start_date = Time.zone.today.beginning_of_day
    end_date =  Time.zone.today.end_of_day
    clause = ''
    case 
      when params[:report].eql?('respondent_view') then 
        clause << ' respondent_id is not null and respondent_id = ? ' 
      when params[:report].eql?('curr_state') then 
        if params[:po].eql?('951') then
			clause << ' branch_id = ? and respondent_id = 951'  
		else
			clause << ' branch_id = ? '  
		end
    end
     
    case
      when created.eql?('Today') then
        start_date = Time.zone.today.beginning_of_day
        end_date =  Time.zone.today.end_of_day
      when created.eql?('Range') then
        start_date = start_d_s.to_time.beginning_of_day
        end_date =  end_d_s.to_time.beginning_of_day
      when created.eql?('On') then
        start_date = start_d_s.to_time.beginning_of_day
        end_date =  start_d_s.to_time.end_of_day
    end
    
    
    unless params[:state].eql?('All') then
      unless created.eql?('All') then
        paginate :page => params[:page], :conditions => [clause << ' and state = ? '<< ' and created_at >= ? and created_at <= ? ', 
        params[:branch_id], params[:state], start_date, end_date], :order => 'created_at, id DESC'
      else
        paginate :page => params[:page], :conditions => [clause << ' and state = ? ', 
        params[:branch_id], params[:state] ], :order => 'created_at, id DESC'
      end
    else
      unless created.eql?('All') then
        paginate :page => params[:page], :conditions => [clause << ' and created_at >= ? and created_at <= ? ', 
        params[:branch_id], start_date, end_date], :order => 'created_at, id DESC'
      else
        paginate :page => params[:page], :conditions => [clause , 
        params[:branch_id]], :order => 'created_at, id DESC'
      end
    end
    
  end  
  
  def self.to_jit(ibtrStat)
    {
      'label' => ibtrStat.branch_id,
      'values' => [ibtrStat.new_cnt, ibtrStat.assigned_cnt, ibtrStat.poassigned_cnt, ibtrStat.poplaced_cnt, ibtrStat.fulfilled_cnt, ibtrStat.dispatched_cnt, ibtrStat.received_cnt, ibtrStat.delivered_cnt, ibtrStat.timedout_cnt, ibtrStat.declined_cnt, ibtrStat.cancelled_cnt , ibtrStat.duplicate_cnt ]
    }
  end    
  
  def self.resp_to_jit(ibtrStat)
    {
      'label' => ibtrStat.respondent_id,
      'values' => [ibtrStat.assigned_cnt, ibtrStat.poplaced_cnt, ibtrStat.fulfilled_cnt, ibtrStat.declined_cnt, ibtrStat.dispatched_cnt ]
    }
  end    
end
