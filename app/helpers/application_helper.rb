# -*- encoding : utf-8 -*-
module ApplicationHelper
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def active?(link_path)
    if params[:controller] == 'user' && params[:action] == 'show' && (link_path.include? 'user')
      link_path = "/user/#{params[:user_id]}"
    end
    current_page?(link_path) ? 'active' : ''
  end
end
