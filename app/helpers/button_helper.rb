module ButtonHelper
  def submit_button_text
    if controller.action_name == 'new'
      "Slurp & Share"
    else
      "Refine Your Review"
    end
  end
end
