class Batch < ActiveRecord::Base

  def expired?
    self.state.eql?('Expired') or self.expires_on <= Time.zone.now 
  end

  def open?
    self.state.eql?('Open') and !self.expired?
  end
  
  def self.update_reassgn_items(batch_id)
    batch = Batch.find(batch_id)
    if batch.open? 
      reassign_items = IbtReassign.find(:all, :conditions => ['batch_id =? ', batch_id], :order => 'id')
      reassign_items.each do |item|
        if (((item.ibtr.title_id != item.title_id) or (item.ibtr.respondent_id.to_i != item.respondent_id) or (item.ibtr.state != 'Assigned')) and item.not_done?)
          item.done!
        end
      end
    end
  end

end
