class Consignment < ActiveRecord::Base
	include ActiveRecord::Transitions

	has_many :goods, :dependent => :destroy
	accepts_nested_attributes_for :goods, :allow_destroy => :true, :reject_if => lambda { |a| a[:book_no].blank? }

  attr_accessible :consignor, :consignee, :origin_id, :destination_id, :goods_attributes, :goods_delivered_count
  
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
			transitions :to => :Pickedup, :from => :Open, :on_transition => lambda { |consignment| consignment.pickup_date = Time.zone.now }
		end
		event :deliver do
			transitions :to => :Delivered, :from => [:Open, :Pickedup], :on_transition => lambda { |consignment|
          consignment.delivery_date = Time.zone.now
          goods_delivered_count = Good.where(:consignment_id => consignment.id, :state => 'Delivered').size
      }
		end
		event :cancel do
			transitions :to => :Cancelled, :from => [:Open, :Pickedup], :on_transition => lambda { |consignment| consignment.pickup_date = nil }
		end
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
		
	private
	
	def set_defaults
    if self.waybill_no.nil? 
      self.waybill_no = 'IBT/'+ self.origin.name[0..1]+'/'+ self.destination.name[0..1]+'/'+Time.zone.now.strftime("%Y%m%d%I%M%S%3N")
    end
    if origin_address.nil?
      self.origin_address = origin.address
    end
    if destination_address.nil?
      self.destination_address = origin.address
	  end
  end
end
