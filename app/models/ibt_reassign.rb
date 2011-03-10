class IbtReassign < ActiveRecord::Base
  include ActiveRecord::Transitions
  belongs_to :batch, :counter_cache => :item_count, :autosave => :true
  belongs_to :title
  belongs_to :respondent, :class_name => 'Branch', :foreign_key => 'respondent_id'
  belongs_to :ibtr
  belongs_to :good
  
	state_machine do
  	state :Open
    state :Done

		event :done do
			transitions :to => :Done, :from => :Open, :on_transition => lambda { |ibt_reassign|
          ibt_reassign.batch.closed_count += 1}
		end
		event :undo_done do
			transitions :to => :Open, :from => :Done, :on_transition => lambda { |ibt_reassign|
          ibt_reassign.batch.closed_count -= 1}
		end
	end

  def done?
    self.state == 'Done' ? true : false
  end
  def not_done?
    self.state == 'Done' ? false : true
  end
  

end
