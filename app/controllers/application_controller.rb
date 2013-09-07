class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_user

  def set_user
    session[:current_user] ||= Consultant.find_by employee_id: 13080
    #TODO: Placeholder till CAS integration
  end
  
end
