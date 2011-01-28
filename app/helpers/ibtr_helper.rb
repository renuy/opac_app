module IbtrHelper  
  
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
  
  def report_msg(create, start_d_s, end_d_s)
    mesg = ""
    if (!start_d_s.nil?)
      start_s = start_d_s["start(3i)"] + '-' + start_d_s["start(2i)"] +'-'+ start_d_s["start(1i)"]
    end
    if (!end_d_s.nil?)
      end_s = end_d_s["end(3i)"] + '-' + end_d_s["end(2i)"] +'-'+ end_d_s["end(1i)"]
    end
    case
    when create.eql?("All") then mesg = " till now "
    when create.eql?("On") then mesg = " raised on "+start_s
    when create.eql?("Today") then mesg = "raised today"
    when create.eql?("Range") then mesg = "raised between "+ start_s+" and "+end_s
    end
  end
end
