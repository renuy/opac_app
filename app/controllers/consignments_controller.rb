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
end
