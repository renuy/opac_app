class IbtrVersion < ActiveRecord::Base

  def self.curr_view_qry( created, start_date, end_date)
    ibtr_stats = nil
    if created == 'All'
      ibtr_stats = IbtrVersion.find(:all, :select => " branch_id , "+
      "sum(decode(state,'New',1,0)) as new_cnt,  "+
      "sum(decode(state,'Assigned',1,0)) as assigned_cnt,  "+
      "sum(decode(state,'Fulfilled',1,0)) as fulfilled_cnt,  "+
      "sum(decode(state,'Received',1,0)) as received_cnt, "+
      "sum(decode(state,'Declined',1,0)) as declined_cnt, "+
      "sum(decode(state,'Duplicate',1,0)) as duplicate_cnt, "+
      "sum(decode(state,'Cancelled',1,0)) as cancelled_cnt " , 
      :group => " branch_id ",
      :order => "branch_id")
    else 
      ibtr_stats = IbtrVersion.find(:all, :select => " branch_id , "+
      "sum(decode(state,'New',1,0)) as new_cnt,  "+
      "sum(decode(state,'Assigned',1,0)) as assigned_cnt,  "+
      "sum(decode(state,'Fulfilled',1,0)) as fulfilled_cnt,  "+
      "sum(decode(state,'Received',1,0)) as received_cnt, "+
      "sum(decode(state,'Declined',1,0)) as declined_cnt, "+
      "sum(decode(state,'Duplicate',1,0)) as duplicate_cnt, "+
      "sum(decode(state,'Cancelled',1,0)) as cancelled_cnt " , 
      :conditions => ["created_at >= ? and created_at <= ? ", start_date, end_date], 
      :group => "  branch_id ",
      :order => "branch_id")
    end
    
    return ibtr_stats
  end

  def self.respondent_view_qry( created, start_date, end_date)
  ibtr_stats = nil  
    if created == 'All'
      ibtr_stats = IbtrVersion.find(:all, :select => "  respondent_id , "+
      "sum(decode(state,'Assigned',1,0)) as assigned_cnt,  "+
      "sum(decode(state,'Fulfilled',1,0)) as fulfilled_cnt,  "+
      "sum(decode(state,'Declined',1,0)) as declined_cnt, "+
      "sum(decode(state,'Cancelled',1,0)) as cancelled_cnt " , 
      :group => " respondent_id ",
      :order => "to_number(respondent_id)")
    else 
      ibtr_stats = IbtrVersion.find(:all, :select => " respondent_id  , "+
      "sum(decode(state,'Assigned',1,0)) as assigned_cnt,  "+
      "sum(decode(state,'Fulfilled',1,0)) as fulfilled_cnt,  "+
      "sum(decode(state,'Declined',1,0)) as declined_cnt, "+
      "sum(decode(state,'Cancelled',1,0)) as cancelled_cnt " , 
      :conditions => ["created_at >= ? and created_at <= ? ", start_date, end_date], 
      :group => " respondent_id ",
      :order => "to_number(respondent_id)")
    end
    ibtr_stats
  end
  
  def self.get_ibtr_version_stats(params, start_d_s, end_d_s)
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
        ibtr_stats = IbtrVersion.respondent_view_qry( created, start_date, end_date)
        
      when params[:report].eql?('curr_state') then 
        ibtr_stats = IbtrVersion.curr_view_qry( created, start_date, end_date)
    end
    
    return ibtr_stats
  end

end
