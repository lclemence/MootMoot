class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale

  layout :layout_by_role
   
  def set_locale
    available = %w{en fr}
    I18n.locale = request.compatible_language_from(available)
  end


  private
  def verify_admin
    redirect_to root_url unless current_user && ( current_user.has_role? :admin )
  end

  def layout_by_role
    if current_user && ( current_user.has_role? :admin )
      "admin"
    else
      if params['_escaped_fragment_']
        "empty"
      else
        "application"
      end
    end
  end
end
