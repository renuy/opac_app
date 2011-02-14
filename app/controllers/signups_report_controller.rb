class SignupsReportController < ApplicationController
  respond_to :html, :js, :json, :xml
  def signups_report
    branch_id = params[:branch_id].to_i
    unless branch_id.nil?
      if branch_id <= 0
        @signups = Signup.find(:all)
        @processed = Signup.find_all_by_flag_migrated('P')
        @unprocessed = Signup.find_all_by_flag_migrated('U')
        @errorflag = Signup.find_all_by_flag_migrated('E')
      else
        @signups = Signup.find_all_by_branch_id(branch_id)
        @processed = Signup.find_all_by_branch_id_and_flag_migrated(branch_id, 'P')
        @unprocessed = Signup.find_all_by_branch_id_and_flag_migrated(branch_id, 'U')
        @errorflag = Signup.find_all_by_branch_id_and_flag_migrated(branch_id, 'E')
      end    

    report_obj = Hash.new
    report_obj = {'label' => ['Total Signups', 'Processed', 'Un-Processed', 'Error state'],
      'values' => [{'label' => 'Total Signups', 'values' => [@signups.count]},
        {'label' => 'Processed', 'values' => [0,@processed.count,0,0]},
        {'label' => 'Un-Processed', 'values' => [0,0,@unprocessed.count,0]},
        {'label' => 'Error state', 'values' => [0,0,0,@errorflag.count]}
      ]}

    respond_with(report_obj.to_json())
    end
  end

  def report_details
    branch_id = params[:branch_id].to_i
    modifyMode = params[:modifyMode]

    # whitelist : data selected for display
    selectedCol = ["payment_ref", "payment_mode", "security_deposit", "registration_fee",
              "reading_fee", "discount", "paid_amt", "coupon_amt", "coupon_no", "coupon_id",
              "plan_id", "application_no", "membership_no", "employee_no",
              "referrer_member_id", "email", "lphone", "mphone", "address", "name"]

    unless branch_id.nil?
      if branch_id <= 0
        if modifyMode == 'T'
          @detailObj = Signup.find(:all, :select => selectedCol)
        else
          @detailObj = Signup.find_all_by_flag_migrated(modifyMode, :select => selectedCol)
        end
      else
        if modifyMode == 'T'
          @detailObj = Signup.find_all_by_branch_id(branch_id, :select => selectedCol)
        else
          @detailObj = Signup.find_all_by_branch_id_and_flag_migrated(branch_id, 
            modifyMode, :select => selectedCol)
        end
      end

    respond_with(@detailObj.to_json())
    end
  end

end
