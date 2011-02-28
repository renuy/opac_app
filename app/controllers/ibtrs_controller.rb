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

  def reassign_search
    @ibtrs = Ibtr.find(:all, :conditions=> ['id =?' ,params[:id]]).paginate(:page=>params[:page], :per_page=>10)
    render 'index'
  end
  def drillrpt
  
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
    @ibtrs = Ibtr.query(params , start_s, end_s)
    render 'index'
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
    book_no = params[:sort][:book_no]
    isbn = params[:sort][:isbn]
    flg_no_isbn = params[:sort][:flg_no_isbn]
    # check for an existing fulfilled, or dispatched record
    @ibtr = Ibtr.find_by_book_no_and_state(book_no, [:Dispatched,:Fulfilled])
    ib = IbtSort.new
    ib.book_no = book_no
    ib.isbn = isbn
    ib.flg_no_isbn = flg_no_isbn

    respond_to do |format|
      unless @ibtr.nil?
        if @ibtr.state = :Fulfilled
          @ibtr.dispatch!
        end
        ib.ibtr_id = @ibtr.id
        ib.save!
        
        flash[:notice] = "book dispatched to #{@ibtr.card_id} of branch #{@ibtr.branch_id}"
        format.html { redirect_to @ibtr }
        format.xml  # dispatch.xml.erb
      else
        good = Good.find_by_book_no(book_no) #to do: to add date restriction
        if good.nil? 
          status = :precondition_failed
        else
          status = :not_found
          ib.consignment_id = good.consignment_id
        end
        ib.save
        format.html { render :action => "lookup" }
        format.xml  { render :nothing => true, :status => status }
      end
    end  
  end

  def setAltTitle
    @ibtr = Ibtr.find(params[:id])
    unless @ibtr.title_id.to_s.eql?(params[:title_id])
      if @ibtr.update_attributes(:title_id => params[:title_id])
        flash[:notice] = "Successfully changed titleid to " + params[:title_id] +". Please refresh before assigning."
      else
        flash[:error] = "An error occured while trying to update record - "+ @ibtr.errors.full_messages[0]
      end
    else
      flash[:error] = "Same title ids " + params[:title_id]
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
    #@ibtr_version_stats = IbtrVersion.get_ibtr_version_stats(params, start_s, end_s)
    case 
      when params[:report].eql?('respondent_view') then 
        render 'resp_stats'
      when params[:report].eql?('curr_state') then 
        render 'stats'
    end

    
  end
  
  def titleupd
    ibtr = Ibtr.find(params[:ibtr_id])
    book = Book.find(params[:book_no])
    good = Good.find(params[:id])
    
    
    #passing ibtr_id from here will as it is be overwritten with whatever goods finds in set_good_details !!! 
    #hence the following order of updates matter as goods overwrites ibtr_id to null in case it does not find the correct ibtr_id in assigned state.
    ibtr.fulfill
    ibtr.update_attributes( :title_id => book.title_id,
                            :book_no => book.book_no,
                            :state => ibtr.current_state)
    good.update_attributes( :ibtr_id => params[:ibtr_id])
    

    flash[:notice] = "Successfully fullfilled"
    
    redirect_to :action=>"booksearch" , :controller => "consignments"
  end

end
