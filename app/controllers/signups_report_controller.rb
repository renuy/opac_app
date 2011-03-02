class SignupsReportController < ApplicationController
  def signups_report
    respond_to do |format|
      format.html
    end
  end

  def report_details
    branch_id = params[:branch_id].to_i
    modifyMode = params[:modifyMode]
    start_date = params[:start_date]
    end_date = params[:end_date]

    # whitelist : data selected for display
    selectedCol = ["payment_ref", "payment_mode", "security_deposit", "registration_fee",
              "reading_fee", "discount", "paid_amt", "coupon_amt", "coupon_no", "coupon_id",
              "plan_id", "application_no", "membership_no", "employee_no",
              "referrer_member_id", "email", "lphone", "mphone", "address", "name"]

    unless branch_id.nil?      
      if modifyMode == 'T'
        @detailObj = Signup.find(:all, :conditions =>
            ["branch_id = ? AND created_at >= to_date(?, 'DD-MM-YY') AND
             created_at <= (to_date(?, 'DD-MM-YY') + 1) AND membership_no != '-'",
          branch_id, start_date, end_date], :select => selectedCol)
      end
    end

    render :partial => 'reportDetails'
  end

  def newMemberReversal
    card_number = params[:card_number]
    @signup = Signup.find_by_membership_no(card_number)

    # subscribe new member reversal event, then update the signup card number to '-'
    eObj = @signup.generateNMReversalEvent(current_user.id.to_s, user_session['current_branch'].id.to_s)
    if eObj.save
      @signup.update_attribute("membership_no", "-")
    end

    respond_to do |format|
      format.html
    end
  end

end
