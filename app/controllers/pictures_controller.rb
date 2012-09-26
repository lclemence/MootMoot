class PicturesController < ApplicationController
  before_filter :authenticate_user!

  def show
#    redirect_to root_path, :anchor => "!#{params[:id]}"
  end
end
