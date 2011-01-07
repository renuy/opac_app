module IbtrHelper  
  def image_url(titleId)
    if titleId then
      "http://justbooksclc.com/images#{titleId/10000}/titles#{titleId/10000}/#{titleId}.jpg"
    else
      "#"
    end
  end
  
  def action_buttons(state, edit_id, edit_event_id)
    buttons = ""
    actions = []
    case 
    when state.eql?("New") then actions << "Assign" << "Cancel"
    when state.eql?("Declined") then actions << "Assign" << "Cancel"
    when state.eql?("Assigned") then actions << "Decline" << "Fulfill" << "Cancel"
    when state.eql?("Fulfilled") then actions << "Dispatch"
    when state.eql?("Dispatched") then actions << "Receive"
    end
    
    actions.sort!
    
    actions.each { |action|
        buttons << button_to_function(action, "$('#{edit_id} #{edit_event_id}').val('#{action.downcase}');$('#{edit_id}').submit()", :class => ".ibtr_#{action.downcase}" )
    }
    buttons
  end
  
end
