class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale

  layout :layout_by_role
   
  def set_locale
    I18n.locale = 'en'
  end


  private
  def verify_admin
    redirect_to root_url unless current_user && ( current_user.has_role? :admin )
  end

  def layout_by_role
    if current_user && ( current_user.has_role? :admin )
      "admin"
    else
      "application"
    end
  end
end
