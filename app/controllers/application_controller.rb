class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_commissions
  
  
  def set_commissions
    if user_signed_in?
      @commission_reports = CommissionReport.includes(:account_manager, :recruiter, :support, :customer).distinct if current_user.admin?
      @commission_reports = current_user.reports if !current_user.admin?
    else
      @commission_reports = CommissionReport.none
    end
  end
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :role, :advanced])
  end
  
  def after_sign_in_path_for(resource)
    if params[:redirect_to].present?
      store_location_for(resource, params[:redirect_to])
    elsif request.referer == new_session_url(resource)
      profile_path(resource)
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end
end
