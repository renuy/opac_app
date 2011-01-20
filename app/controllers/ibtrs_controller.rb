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

  # dispatch an ibtr, in case one is already dispatch, return the details of the ibtr
  # so that the user can reprint the dispatch slip
  def sort
    book_no = params[:book_no]
    
    # check for an existing fulfilled, or dispatched record
    @ibtr = Ibtr.find_by_book_no_and_state(book_no, [:Dispatched,:Fulfilled])

    respond_to do |format|
      unless @ibtr.nil?
        if @ibtr.state = :Fulfilled
          @ibtr.dispatch!
        end
        flash[:notice] = "book dispatched to #{@ibtr.card_id} of branch #{@ibtr.branch_id}"
        format.html { redirect_to @ibtr }
        format.xml  # dispatch.xml.erb
      else
        format.html { render :action => "lookup" }
        format.xml  { render :nothing => true, :status => :not_found }
      end
    end  
  end

end
