class IbtrsController < ApplicationController
  def index
    @ibtrs = Ibtr.search(params)
  end
  
  def update
    @ibtr = Ibtr.find(params[:id])
    @ibtr.processEvent(params[:ibtr][:event])
    @ibtr.update_attributes(:respondent_id => params[:ibtr][:respondent_id], 
                            :reason_id => params[:ibtr][:reason_id], 
                            :comments => params[:ibtr][:comments], 
                            :state => @ibtr.current_state)
    flash[:notice] = "Successfully #{@ibtr.state} " << (params[:ibtr][:event].eql?("assign") ? "to #{@ibtr.respondent_id}!" : "!")
  rescue Transitions::InvalidTransition
    flash[:error] = "Cannot #{params[:ibtr][:event]} a request that is #{@ibtr.state}."
  end  
  
  def search
    @ibtrs = Ibtr.complexSearch(params)
  end

  def show
    @ibtr = Ibtr.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  # show.xml.erb
    end
  end

  def lookup
    
  end
  
  def fulfill
    book_no = params[:bookno]
    @ibtr = Ibtr.find_for_fulfill(book_no)
    
    respond_to do |format|
      if !@ibtr.id.nil? and @ibtr.set_fulfill(book_no)
        flash[:notice] = "book fulfilled to #{@ibtr.card_id} of branch #{@ibtr.branch}"
        format.html { redirect_to(@ibtr, :notice => "book fulfilled to #{@ibtr.card_id} of branch #{@ibtr.branch}") }
        format.xml  { head :ok }
      else  
        format.html { render :action => "lookup" }
        format.xml  { render :xml => @ibtr.errors, :status => :unprocessable_entity }
      end
    end  
  end
  
  def stats
    start_d_s = params[:start]
    end_d_s = params[:end]
    start_s = ""
    end_s = ""
    
    if (!start_d_s.nil?)
      start_s = start_d_s["start(3i)"] + '-' + start_d_s["start(2i)"] +'-'+ start_d_s["start(1i)"]
    end
    if (!end_d_s.nil?)
      end_s = end_d_s["end(3i)"] + '-' + end_d_s["end(2i)"] +'-'+ end_d_s["end(1i)"]
    end

    @ibtr_stats = Ibtr.get_ibtr_stats(params, start_s, end_s)
    
    render 'stats'
  end
end
