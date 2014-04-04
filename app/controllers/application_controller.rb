class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :configure_permitted_parameters, if: :devise_controller?
  
  protected  
  
  def redirect_not_authorized
    redirect_to root_url, alert: "Action not authorized."
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) {|u| 
      u.permit(:name, :email, :password, :password_confirmation, language_ids: [])}
    devise_parameter_sanitizer.for(:account_update) {|u|
      u.permit(:name, :email, :password, :password_confirmation, :current_password, language_ids: [])}
  end
end
