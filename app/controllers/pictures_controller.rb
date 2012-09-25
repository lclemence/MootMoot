class PicturesController < ApplicationController
  def show
    redirect_to root_path, :anchor => "!#{params[:id]}"
  end
end
