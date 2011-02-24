class Signup < ActiveRecord::Base
  
  PAYMENT_MODES = {
    :cash   => 1,
    :check  => 2, 
    :card   => 3
  }  
  
  attr_accessor :check_no, :card_no
  attr_accessible :name, :address, :mphone, :lphone, :email, :referrer_member_id, 
    :employee_no, :plan_id, :branch_id, :signup_months, :payment_mode, :membership_no, 
    :application_no, :coupon_no, :coupon_id, :coupon_amt, :paid_amt
  
  belongs_to :user, :foreign_key => 'created_by'
  belongs_to :user, :foreign_key => 'modified_by'
  belongs_to :plan
  belongs_to :branch
  
  
  validates :name, :presence => true, :length => { :minimum => 2, :maximum => 100 }
  validates :address, :presence => true, :length => { :minimum => 2, :maximum => 100 }
  validates :referrer_member_id, :length => { :maximum => 10 }
  validates :employee_no, :length => { :maximum => 10 }
  validates :membership_no, :presence => true, :uniqueness => true, :length => { :is => 7 }
  validates :paid_amt, :presence => true, :numericality => { :greater_than => 0 }
# validates :application_no, :presence => true, :uniqueness => true, :length => { :maximum => 10 }
  validates :payment_mode, :presence => true, :numericality => {:greater_than => 0, :less_than => 4 }
  validates :email, :email => true
  validate :payment_ref_should_not_be_blank
  validate :atleast_one_phone_number_required
  validate :coupon_no_should_not_be_blank
  validate :paid_amt_greater_than_bill_amt
  
  before_save :set_defaults
    
  def coupon_no_should_not_be_blank
      if coupon_no.blank?
        errors.add(:coupon_no, "should not be blank") unless coupon_id.nil?
      end
    end
  
  def payment_ref_should_not_be_blank
    if payment_ref.blank? 
      errors.add(:check_no, "should not be blank") if payment_mode == Signup::PAYMENT_MODES[:check]
      errors.add(:card_no, "should not be blank") if payment_mode == Signup::PAYMENT_MODES[:card]
    end
  end
  
  def atleast_one_phone_number_required
    if mphone.blank? && lphone.blank?
      errors.add(:mphone, "is required")
    end
    unless lphone.blank?
      begin
        errors.add(:lphone, "is more than 10 digits") if lphone.to_s.length > 10
        errors.add(:lphone, "is less than 8 digits") if lphone.to_s.length < 8
      end
    end
    unless mphone.blank?
      begin
        errors.add(:mphone, "should be 10 digits") if mphone.to_s.length != 10
      end
    end
  end

  def paid_amt_greater_than_bill_amt
    unless paid_amt.blank?
      plan = Plan.find(plan_id)
      bill_amt = plan.total_due_for_term(signup_months, coupon_id)
      errors.add(:paid_amt, "is more than Bill Amount") if paid_amt.to_d > bill_amt.to_d
    end
  end


  def generateNMReversalEvent(created_by, branch_id)
    eventObj = Event.new

    eventObj.event_type = "NEW_MEMBER_REVERSAL"
    eventObj.version = "1"
    eventObj.status = "P"
    eventObj.val1 = self.membership_no
    eventObj.val2 = created_by
    eventObj.val3 = branch_id
    eventObj.val4 = self.address
    eventObj.val5 = self.advance_amt
    eventObj.val6 = self.application_no
    eventObj.val7 = self.branch_id
    eventObj.val8 = self.coupon_amt
    eventObj.val9 = self.coupon_id
    eventObj.val10 = self.coupon_no
    eventObj.val11 = self.discount
    eventObj.val12 = self.email
    eventObj.val13 = self.employee_no
    eventObj.val14 = self.expiry_date
    eventObj.val15 = self.lphone
    eventObj.val16 = self.mphone
    eventObj.val17 = self.name
    eventObj.val18 = self.overdue_amt
    eventObj.val19 = self.paid_amt
    eventObj.val20 = self.payment_mode
    eventObj.val21 = self.payment_ref
    eventObj.val22 = self.plan_id
    eventObj.val23 = self.reading_fee
    eventObj.val24 = self.referrer_member_id
    eventObj.val25 = self.registration_fee
    eventObj.val26 = self.remarks
    eventObj.val27 = self.security_deposit
    eventObj.val28 = self.signup_months
    eventObj.val29 = self.start_date
    eventObj.val30 = self.flag_migrated

    return eventObj
  end
  

  private 
  
  def set_defaults
    plan = Plan.find(plan_id)
    
    self.referrer_cust_id = nil
    self.application_no = '1'
    
    unless self.coupon_id.nil?
      coupon = plan.coupons.find(self.coupon_id)
      self.discount = coupon.discount
      self.coupon_amt = coupon.amount
    else
      self.discount = 0
      self.coupon_amt = 0
      self.coupon_no = nil
    end

    # these values are possibly allowed to be changed during sign-up
    # dont have time to do this
    self.security_deposit = plan.security_deposit
    self.registration_fee = plan.registration_fee
    self.reading_fee = plan.reading_fee_for_term(self.signup_months)
    self.advance_amt = 0    
    self.overdue_amt = 0

    #part payment starts
    bill_amt = self.security_deposit + self.registration_fee + self.reading_fee - (self.discount + self.coupon_amt)    
    actual_paid_amt = self.paid_amt
    
    if bill_amt > actual_paid_amt
      self.overdue_amt = bill_amt - actual_paid_amt
    end
    #part payment ends    
    
    self.start_date = Time.zone.today
    if plan.subscription
      self.expiry_date = self.start_date.months_since(self.signup_months)
    else
      self.expiry_date = self.start_date.months_since(100)
    end
  end

  
end
