class GoodsController < ApplicationController

  def index
    @goods = Good.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @goods }
    end
  end

  def show
    @good = Good.find(params[:id])

    respond_to do |format|
      format.html { redirect_to @good.consignment } # show.html.erb
      format.xml  { render :xml => @good }
    end
  end

  def new
    @good = Good.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @good }
    end
  end

  def edit
    @good = Good.find(params[:id])
  end

  def create
    @good = Good.new(params[:good])

    respond_to do |format|
      if @good.save
        format.html { redirect_to(@good, :notice => 'Good was successfully created.') }
        format.xml  { render :xml => @good, :status => :created, :location => @good }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @good.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    @good = Good.find(params[:id])

    respond_to do |format|
      if @good.update_attributes(params[:good])
        format.html { redirect_to(@good, :notice => 'Good was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @good.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @good = Good.find(params[:id])
    @good.destroy

    respond_to do |format|
      format.html { redirect_to(goods_url) }
      format.xml  { head :ok }
    end
  end

end
