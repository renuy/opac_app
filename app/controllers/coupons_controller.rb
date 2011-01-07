class CouponsController < ApplicationController
  def show
    @coupon = Coupon.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
      format.js
    end
    
  end

end
