class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  
  # Stuff that's going to return a 404
  rescue_from ActiveRecord::RecordNotFound do
    render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
  end
  
  # Stuff that's going to return a 422
  rescue_from ArgumentError do
    render :file => "#{Rails.root}/public/422", :layout => false, :status => :unprocessable_entity
  end
  
  # Stuff that's going to return a 500
  rescue_from ApplicationHelper::IllegalStateError do
    render_internal_server_error
  end
  
  rescue_from ActiveRecord::RecordInvalid do
    render_internal_server_error
  end
  
  # Utility methods
  def render_internal_server_error
    render :file => "#{Rails.root}/public/500", :layout => false, :status => :exception
  end
  
end
