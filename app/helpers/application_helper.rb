# -*- encoding : utf-8 -*-
module ApplicationHelper
  # Used for when data is in a squiffy state
  class IllegalStateError < StandardError
  end
  
  def is_active?(link_path)
    if(params[:action] == 'show' && (link_path.include? "user"))
      link_path = "/user/#{controller.show.id}"
    end
    current_page?(link_path) ? "active" : ""
  end
end
