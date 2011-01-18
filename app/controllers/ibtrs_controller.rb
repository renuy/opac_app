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
    if (params[:f_error].nil?)
      @f_errors = []
    end
  end
  
  def fulfill
    book_no = params[:bookno]
    branch_id = params[:branch_id]
    if branch_id.nil?
      branch_id = 951
    end
    @f_errors =[]
    
    @ibtr = Ibtr.find_for_fulfill(book_no)
    if !@ibtr.nil?
      
        if @ibtr.set_fulfill(book_no, branch_id)
          respond_to do |format|
            flash[:notice] = "book fulfilled to #{@ibtr.card_id} of branch #{@ibtr.branch}"
            format.html { redirect_to(@ibtr, :notice => "book fulfilled to #{@ibtr.card_id} of branch #{@ibtr.branch}") }
            format.xml  { head :ok }
          end
          return
        else
            @f_errors << @ibtr.errors
        end
      
    else
      @f_errors << "Book does not match any IBTR."
    end  
    
    @ibtr = Ibtr.find_by_book_no(book_no)  
    #render 'lookup'
    respond_to do |format|
      format.html { render "/ibtrs/lookup" ,  :f_error => 'true' }
      format.xml  { render :xml => @f_error, :status => :unprocessable_entity }
    end
  end

end
