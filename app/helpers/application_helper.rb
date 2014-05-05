# -*- encoding : utf-8 -*-
module ApplicationHelper
  # Used for when data is in a squiffy state
  class IllegalStateError < StandardError
  end

  def active?(link_path)
    if params[:controller] == 'user' && params[:action] == 'show' && (link_path.include? "user")
      link_path = "/user/#{controller.show.id}"
    end
    current_page?(link_path) ? "active" : ""
  end
end
