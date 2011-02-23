class IbAssignment < ActiveRecord::Base


def self.allRacks(params)
	
	picked_title_ids = [0]
	title_ids = IbtHiddenReq.find(:all, :select => 'distinct title_id', :conditions => ['respondent_id = ? ',  params[:branchVal]])
	title_ids.each do |t|
		picked_title_ids << t.title_id
	end
	
	if params[:criteria] == 'unpicked'
		ib_assignemnts = IbAssignment.find(:all, :select => 'distinct category, rack ', :conditions => ['book_branch_id = ? AND title_id NOT IN ( ? )', params[:branchVal], picked_title_ids],:order => 'category, substr(rack,1)').paginate(:page => params[:page],:per_page => 5)
	elsif params[:criteria] == 'picked'
		IbAssignment.find(:all, :select => 'distinct category, rack ', :conditions => ['book_branch_id = ? AND title_id IN (? ) ', params[:branchVal], picked_title_ids],:order => 'category, substr(rack,1)').paginate(:page => params[:page],:per_page => 5)
	else
		IbAssignment.find(:all, :select => 'distinct category, rack ', :conditions => ['book_branch_id = ? ', params[:branchVal]],:order => 'category, substr(rack,1)').paginate(:page => params[:page],:per_page => (params[:prn].eql?('prn') ? 5000 : 5) )
	end
	
end

def self.allShelves(branchVal, rack, category , criteria)
	
	picked_title_ids = [0]
	title_ids = IbtHiddenReq.find(:all, :select => 'distinct title_id', :conditions => ['respondent_id = ? ',  branchVal])
	title_ids.each do |t|
		picked_title_ids << t.title_id
	end
	if criteria == 'unpicked'
		IbAssignment.find(:all, :select => 'distinct rack, category, shelf ', :conditions => ['book_branch_id = ? AND rack = ? AND category = ? AND title_id NOT IN (?) ', 
				branchVal, 
				rack,
				category,
				picked_title_ids
				], :order => 'shelf')
	elsif criteria == 'picked'
		IbAssignment.find(:all, :select => 'distinct rack, category, shelf ', :conditions => ['book_branch_id = ? AND rack = ? AND category = ? AND title_id IN (?) ', 
				branchVal, 
				rack,
				category,
				picked_title_ids
				], :order => 'shelf')
	else
		IbAssignment.find(:all, :select => 'distinct rack, category, shelf ', :conditions => ['book_branch_id = ? AND rack = ? AND category = ?', 
				branchVal, 
				rack,
				category
				])
	end
end

def self.allTitles(branchVal, rack, category ,shelf , criteria)

	picked_title_ids = [0]
	title_ids = IbtHiddenReq.find(:all, :select => 'distinct title_id', :conditions => ['respondent_id = ? ',  branchVal])
	title_ids.each do |t|
		picked_title_ids << t.title_id
	end

	if criteria == 'unpicked'
		assigned_titles = IbAssignment.find(:all, :select => 'distinct title_id, rack, category, shelf, \'u\' as picked ', :conditions => ['book_branch_id = ? AND rack = ? AND category = ? AND shelf =?  AND title_id NOT IN (?) ', 
				branchVal, 
				rack,
				category,
				shelf,
				picked_title_ids
				])
	
	elsif criteria == 'picked'
		assigned_titles = IbAssignment.find(:all, :select => 'distinct title_id, rack, category, shelf, \'p\' as picked ', :conditions => ['book_branch_id = ? AND rack = ? AND category = ? AND shelf =?  AND title_id IN (?) ', 
				branchVal, 
				rack,
				category,
				shelf,
				picked_title_ids
				])
	else
		assigned_titles = IbAssignment.find(:all, :select => 'distinct title_id, rack, category, shelf, \'p\' as picked ', :conditions => ['book_branch_id = ? AND rack = ? AND category = ? AND shelf =?', 
				branchVal, 
				rack,
				category,
				shelf
				])
		assigned_titles.each do |t|
			if picked_title_ids.index(t.title_id).nil?
				t.picked = "u"
			end
		end
		return assigned_titles
	end
end

end
