class Consignment < ActiveRecord::Base
	include ActiveRecord::Transitions

	has_many :goods, :dependent => :destroy
	accepts_nested_attributes_for :goods, :allow_destroy => :true, :reject_if => lambda { |a| a[:book_no].blank? }

	attr_accessible :consignor, :consignee, :origin_id, :destination_id, :goods_attributes, :goods_delivered_count, :pickup_date, :delivery_date

  
  belongs_to :origin, :class_name => 'Branch', :foreign_key => 'origin_id'
  belongs_to :destination, :class_name => 'Branch', :foreign_key => 'destination_id'
  	
  validates :consignor, :presence => true, :length => { :maximum => 30 }
  validates :consignee, :presence => true, :length => { :maximum => 30 }
  validates :origin_id, :presence => true
  validates :destination_id, :presence => true
  validate :origin_destination_not_same
  
	state_machine do
  	state :Open # first one is the initial state
  	state :Pickedup
  	state :Delivered
  	state :Cancelled

		event :pickup do
			transitions :to => :Pickedup, :from => :Open, :on_transition => lambda {|consignment| consignment.dopickup }
		end
		event :deliver do
			transitions :to => :Delivered, :from => :Pickedup, :on_transition => lambda { |consignment| consignment.delivery_date = Time.zone.now }
		end
		event :cancel do
			transitions :to => :Cancelled, :from => [:Open, :Pickedup], :on_transition => lambda { |consignment| consignment.pickup_date = nil }
		end
	end
	
  def dopickup
    pickup_date = Time.zone.now
    IbtrMailer.consignment_pickup_advice(id).deliver
    save
  end
  
  def delivered
    
    case
      when state.eql?("Open") then deliver!
      when state.eql?("Pickedup") then deliver!
      when state.eql?("Delivered") then update_attributes(:goods_delivered_count => Good.where(:consignment_id => id, :state => 'Delivered').size)
    end
  end
	
	def origin_destination_not_same
	  if origin_id == destination_id
	    errors.add(:destination_id, ' is the same as origin')
    end
	end
	
	before_save :set_defaults

	def processEvent!(event)
		case 
			when event.eql?("pickup") then pickup!
			when event.eql?("deliver") then deliver!
			when event.eql?("cancel") then cancel!
		end
		true
	rescue Transitions::InvalidTransition
	  false
	end
	
  def self.get_stats(params, start_d_s, end_d_s)
    created = params[:Created]
    branch_id = params[:branch_id]
    start_date = Time.zone.today.beginning_of_day
    end_date =  Time.zone.today.end_of_day
    case 
      when created.eql?('Today')
        start_date = Time.zone.today.beginning_of_day
        end_date =  Time.zone.today.end_of_day
      when created.eql?('Range')
        start_date = start_d_s.to_time.beginning_of_day
        end_date =  end_d_s.to_time.beginning_of_day
      when created.eql?('On')
        start_date = start_d_s.to_time.beginning_of_day
        end_date =  start_d_s.to_time.end_of_day
    end
    cons = nil
    
    if (branch_id.eql?('0') ) then
      if created.eql?('All') then 
        cons = Consignment.find(:all, :order => ' id DESC').paginate(:page => params[:page], :per_page => 10)
      else
        cons =  Consignment.find(:all, :conditions => [' created_at >= ? and created_at <= ? ', 
        start_date, end_date], :order => ' id DESC').paginate(:page => params[:page], :per_page => 10)
      end
    elsif
      if created.eql?('All') then 
        cons = Consignment.find(:all, :conditions => ['origin_id = ? ', branch_id],:order => ' id DESC').paginate(:page => params[:page], :per_page => 10)
        
      else
        cons = Consignment.find(:all, :conditions => [' origin_id = ? and created_at >= ? and created_at <= ? ', 
        branch_id, start_date, end_date], :order => ' id DESC').paginate(:page => params[:page], :per_page => 10)
        
      end
    end
    return cons
  end

	private
	
	def set_defaults
	  self.waybill_no = 'IBT/'+ self.origin.name[0..1]+'/'+ self.destination.name[0..1]+'/'+Time.zone.now.strftime("%Y%m%d%I%M%S%3N")
	  if origin_address.nil?
	    self.origin_address = origin.address
	  end
	  if destination_address.nil?
	    self.destination_address = origin.address
	  end
	end
end
