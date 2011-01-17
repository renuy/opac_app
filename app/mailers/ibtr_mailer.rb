class IbtrMailer < ActionMailer::Base
  default :from => "mc@strataretail.co"
  
  def cancelled_notification(ibtr)
    @url = "http://example.com"
    mail(:to => 'akhilesh.kataria@strata.co.in',
         :subject => "This comes from rails")
  end
  
  def consignment_pickup_advice(consignment)
    @consignment = consignment
	mail(:to => 'renu.yarday@strata.co.in',
         :subject => "Consignment pickup advice")
  end
end
