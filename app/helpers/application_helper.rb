module ApplicationHelper
	
	# Return a title on a per-page basis
  def title
    base_title = "Venue Scout"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def logo
    image_tag "logo_small.png", :alt => "Venue Scout"
  end

end
