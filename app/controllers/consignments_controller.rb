class ConsignmentsController < ApplicationController

  def index
    @consignments = Consignment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @consignments }
    end
  end

  def show
    @consignment = Consignment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  # show.xml.erb
    end
  end

  def new
    @consignment = Consignment.new
    3.times { @consignment.goods.build }

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @consignment }
    end
  end

  def edit
    @consignment = Consignment.find(params[:id])
  end


  def create
    @consignment = Consignment.new(params[:consignment])

    respond_to do |format|
      if @consignment.save
        format.html { redirect_to(@consignment, :notice => 'Consignment was successfully created.') }
        format.xml  { render :xml => @consignment, :status => :created, :location => @consignment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @consignment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @consignment = Consignment.find(params[:id])
    respond_to do |format|
      if @consignment.update_attributes(params[:consignment])
        if Good.where(:consignment_id => @consignment.id , :state => 'Delivered').size > 0
          @consignment.delivered
        end 
        format.html { redirect_to(@consignment, :notice => 'Consignment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @consignment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @consignment = Consignment.find(params[:id])
    @consignment.destroy

    respond_to do |format|
      format.html { redirect_to(consignments_url) }
      format.xml  { head :ok }
    end
  end
  
  def transition
    @consignment = Consignment.find(params[:id])
    respond_to do |format|
      if @consignment.processEvent!(params[:event])
        format.html { redirect_to(@consignment, :notice => 'Consignment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @consignment.errors, :status => :unprocessable_entity }
      end
    end    
  end
  
  def booksearch
    book_no = params[:book_no]
    goods = Good.find(:all, :conditions => ['book_no = ? AND ibtr_id IS NULL ',  book_no], :order => 'created_at DESC')
    unless goods.size == 0 
      @good = goods[0]
      @ibtrs= Ibtr.find_all_by_respondent_id_and_state(@good.consignment.origin_id, :Assigned)      
    else
      @good = nil
      @ibtrs = nil
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
    @consignments = Consignment.get_stats(params, start_s, end_s)
    render 'stats'
  end
end
