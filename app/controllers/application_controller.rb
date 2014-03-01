class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  rescue_from ActiveRecord::RecordNotFound do
    render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
  end
  
  rescue_from ActiveRecord::RecordInvalid do
    render :file => "#{Rails.root}/public/500", :layout => false, :status => :exception
  end
  
end
