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

  # fulfill an ibtr, in case one is already fulfilled, return the details of the ibtr
  # so that the user can unfulfill it
  def fulfill
    book_no = params[:book_no]
    
    # check for an existing fulfilled record, if found, then there's nothing else to do
    @ibtr = Ibtr.find_by_book_no_and_state(book_no, 'Fulfilled')
    
    # no record found, so proceed with fulfilling any matching Ibtr
    if @ibtr.nil?
      @ibtr = Ibtr.fulfill(book_no)
    end

    respond_to do |format|
      if @ibtr
        flash[:notice] = "book fulfilled to #{@ibtr.card_id} of branch #{@ibtr.branch_id}"
        format.html { redirect_to @ibtr }
        format.xml  # fulfill.xml.erb
      else
        format.html { render :action => "lookup" }
        format.xml  { render :head => :ok, :status => :not_found }
      end
    end  
  end

end
