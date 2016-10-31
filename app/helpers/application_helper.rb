# -*- encoding : utf-8 -*-
module ApplicationHelper
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def active?(link_path)
    #Handle current_page logic differently based on whether it is a 'normal' route or game_days route (which causes urlexceptions otherwise)
    if params[:controller] == 'user' && params[:action] == 'show' && (link_path.include? 'user') || params[:controller] == 'game_day'
      link_path = "/user/#{params[:user_id]}"
    elsif link_path == '/game_day' and request.original_url.include? '/game_day'
      'active'
    else
      current_page?(link_path) ? 'active' : ''
    end
  end
end
