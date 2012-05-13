class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def verify_admin
    redirect_to root_url unless current_user.has_role? :admin
  end
end
