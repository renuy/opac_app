class SignupsController < ApplicationController
  def new
    signUpMonths = 1
    @plan = Plan.find(params[:plan_id])
    signUpMonths = params[:signup_months].to_i unless params[:signup_months].empty?
    
    if signUpMonths < 1 && @plan.subscription
      redirect_to :plans
    end

    @signup = Signup.new
    @signup.plan_id = @plan.id
    @signup.signup_months = signUpMonths
  end
  
  def create
    @signup = Signup.new(params[:signup]) do |q|
      q.created_by = current_user.id
      q.modified_by = current_user.id
      
      # this does not look to be the best way to work with virtual attributes..
      q.payment_ref = case params[:signup][:payment_mode].to_i
        when Signup::PAYMENT_MODES[:check] then params[:signup][:check_no]
        when Signup::PAYMENT_MODES[:card] then params[:signup][:card_no]
        when Signup::PAYMENT_MODES[:cash] then 'Cash'
        else 'Cash'
        end
        
      q.branch_id = user_session['current_branch'].id
    end
    
    if @signup.save
      redirect_to(@signup, :notice => 'Member Signed Up Successfully')
      SignupMailer.registration_confirmation(@signup).deliver
    else
      @plan = Plan.find(@signup.plan_id)
      render :action => 'new'
    end    
  end
  
  def show
    @signup = Signup.find(params[:id])
  end
  
  def compute
    @plan = Plan.find(params[:plan_id])

    render :partial => 'payment', :locals => { :plan => @plan, :signup_months => params[:signup_months].to_i, :coupon_id => params[:coupon_id].to_i }
  end
end
