module ConsignmentsHelper

  def good_text(state)
    if state == 'Pickedup' 
      "receive" 
    else 
      "unreceive" 
    end
  end
end
