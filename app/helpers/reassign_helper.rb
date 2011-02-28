module ReassignHelper
  def get_link_name(state)
    state.eql?('Open') ? 'pending' : 'done'
  end
  def display_or_not(state)
   state.eql?('Open') ? 'display:visible;' : 'display:none;'
  end
end