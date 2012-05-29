class HomeController < ApplicationController
  def index
    if params['_escaped_fragment_']
      @picture = Picture.find_by_id(params['_escaped_fragment_'])
      render "escaped_fragment"
    elsif !current_user
      redirect_to new_user_session_path
    end
  end

  def fb_auth
    begin
      auth = FbGraph::Auth.new(Facebook.config[:client_id], Facebook.config[:client_secret])
      auth.from_cookie(cookies) # Put whole cookie object (a Hash) here.
      fb_user = auth.user.fetch

      are_friends=false
      fb_user.friends.each do |friend|
        if FB_OWNER_IDS.include? friend.identifier
          are_friends=true
          break
        end
      end

      if are_friends

        if user = User.find_by_email(fb_user.email)
          env['warden'].set_user(user)
        else # Create a user with a stub password.
          user = User.create(:email => fb_user.email, :password => Devise.friendly_token[0,20], :first_name => fb_user.first_name, :last_name => fb_user.last_name)
          user.save(:validate => false)
          env['warden'].set_user(user)
        end
      else
        redirect_to new_user_session_path, :alert =>t(:not_allowed)
      end

      redirect_to root_url

    rescue Exception => e
      redirect_to new_user_session_path, :alert =>e.message
    end
 
  end
end
