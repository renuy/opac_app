class ReassignController < ApplicationController
  def index
    @batch = Batch.find( params[:batch_id])
    @ibt_reassign_batches = IbtReassign.find(:all, :conditions => ['batch_id = ? ', params[:batch_id]], :order => 'state desc, id').paginate(:page => params[:page], :per_page => 10)
  end
  
  def edit
    id = params[:id]
    state = params[:state]
    ibt_reassign = IbtReassign.find(id)
    if state.eql?('Open') 
      ibt_reassign.done!
    else
      ibt_reassign.undo_done!
    end
    redirect_to :action=>"index", :controller=>"reassign", :batch_id=>ibt_reassign.batch_id
  end
  
  def ibt_search
    redirect_to :action=>"reassign_search", :controller=>"ibtrs", :id=>params[:ibtr_id], :page=>1
  end
end
