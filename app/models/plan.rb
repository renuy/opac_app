class Plan < ActiveRecord::Base
  has_and_belongs_to_many :coupons
  
  def monthly_amount
    reading_fee + magazine_fee
  end
  
  def reading_fee_for_term(signUpMonths)
    if subscription
      freeMonths = signUpMonths/6
      monthly_amount * (signUpMonths - freeMonths)
    else
      0.0
    end
  end
  
  def total_due_for_term(signUpMonths, coupon_id)
    if !coupon_id.nil? && coupon_id > 0
      coupon = self.coupons.find(coupon_id)
      rebate = coupon.discount + coupon.amount
    else
      rebate = 0
    end
    security_deposit + registration_fee + reading_fee_for_term(signUpMonths) - rebate
  end
  
  def pay_months_for_term(signUpMonths)
    signUpMonths - signUpMonths/6
  end
end
