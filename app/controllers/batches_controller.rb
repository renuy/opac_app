class BatchesController < ApplicationController
  def index
    batch_type = params[:type]
    @batches = Batch.find(:all, :conditions => ['batch_type = ? ', batch_type], :order => 'id desc').paginate(:page => params[:page], :per_page => 10)
  end
  
  def refresh_reassign_task
    Batch.update_reassgn_items(params[:id])
    redirect_to :action=>"index", :controller=>"reassign", :batch_id=>params[:id]
  end
end
