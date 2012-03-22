class ApplicationController < ActionController::Base
  protect_from_forgery
  
  after_filter  :record_last_visited_page, :unless => :devise_controller?, :if => Proc.new { request.get? && !request.xhr? }

  helper :all
  #helper_method :current_user_session, :current_user
  
  protected
  
  def require_login
  	redirect_to new_user_session_url unless current_user
  end
  
  def ensure_ownership
    if resource_class == User
      deny_access unless current_user == resource
    elsif params.key?(:user_id)
      deny_access unless current_user == User.find(params[:user_id])
    elsif params.key?(:venue_id)
      deny_access unless current_user == Venue.find(params[:venue_id])
    end
  end

  def record_last_visited_page
    session[:user_return_to] = request.path
  end

  
  def deny_access
  	render :text => t('system.access_denied'), status => 403
  end
  

end
