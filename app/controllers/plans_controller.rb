class PlansController < ApplicationController
  def index
    @subscriptionplans = Plan.find_all_by_subscription(1)
    @perbookplans = Plan.find_all_by_subscription(0)    
  end
  
  def show
    @plan = Plan.find(params[:id])
    @coupon = @plan.coupons.find(params[:coupon_id]) unless (params[:coupon_id]).nil?
  end
end
