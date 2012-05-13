class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :layout_by_role



  private
  def verify_admin
    redirect_to root_url unless current_user.has_role? :admin
  end

  def layout_by_role
    if current_user && ( current_user.has_role? :admin )
      "admin"
    else
      "application"
    end
  end
end
