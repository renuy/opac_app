class IbAssignmentsController < ApplicationController
  def index
	@ibt_stock_racks = IbAssignment.allRacks(params)
  end
  
  def pick
	ibt_hide_req = IbtHiddenReq.new
	ibt_hide_req.respondent_id = params[:branchVal]
	ibt_hide_req.title_id = params[:title_id]
	ibt_hide_req.save
	redirect_to :action=>"index", :controller=>"ib_assignments", :branchVal=>params[:branchVal] , :criteria=>params[:criteria], :show=>params[:show]
  end

  def unpick
	ibt_hide_req = IbtHiddenReq.find(:all, :conditions => ['respondent_id = ? AND title_id = ? ', params[:branchVal], params[:title_id]])
	ibt_hide_req.each do |r|
		r.destroy
	end
	redirect_to :action=>"index", :controller=>"ib_assignments", :branchVal=>params[:branchVal] , :criteria=>params[:criteria], :show=>params[:show]
  end
  
  def change
	ibt_search_criteria = IbtSearchCriteria.where(:respondent_id => params[:branchVal])
	now_t = Time.now
	if ibt_search_criteria.nil? or ibt_search_criteria.size == 0 
		ibt_search_c = IbtSearchCriteria.new
		ibt_search_c.respondent_id = params[:branchVal]
		ibt_search_c.time_basis = params[:show] == 'all' ? now_t - 2.year : now_t - 2.day
		ibt_search_c.save
	else
		ibt_search_criteria[0].time_basis = params[:show] == 'all' ? now_t - 2.year : now_t - 2.day
		ibt_search_criteria[0].save
	end
	
	redirect_to :controller=>"ib_assignments", :action=>"index", :branchVal=>params[:branchVal] , :criteria=>params[:criteria] , :show=>params[:show]
  end

  def print
	ibt_search_criteria = IbtSearchCriteria.where(:respondent_id => params[:branchVal])
	old_search_criteria = Time.now - 2.year
	if ibt_search_criteria.nil? or ibt_search_criteria.size == 0 
	
	else
		old_search_criteria = ibt_search_criteria[0].time_basis
		ibt_search_criteria[0].time_basis = Time.now - 2.year
		ibt_search_criteria[0].save
	end
	
	@ibt_stock_racks = IbAssignment.allRacks(params)
	ibt_search_criteria[0].time_basis = old_search_criteria
	ibt_search_criteria[0].save
  end

end
