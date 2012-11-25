class GalleriesController < ApplicationController
  before_filter :verify_admin, :except => :view
  def view
    @galleries_root = Gallery.where("parent_id is null")
    #@galleries = Gallery.all

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @galleries_root.to_json(:include => {:pictures => {}, :child => {:pictures => {}}}) }
#       format.json { render :json => @galleries_root }
    end
  end
end
