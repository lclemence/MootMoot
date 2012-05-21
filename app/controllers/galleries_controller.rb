class GalleriesController < ApplicationController
  before_filter :verify_admin, :except => :view

  def view
    @galleries = Gallery.all

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @galleries.to_json(:include => {:pictures => {}}) }
    end
  end


  # GET /galleries
  # GET /galleries.json
  def index
    @galleries = Gallery.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @galleries }
    end
  end

  # GET /galleries/1
  # GET /galleries/1.json
  def show
    @gallery = Gallery.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @gallery }
    end
  end

  # GET /galleries/new
  # GET /galleries/new.json
  def new
    @gallery = Gallery.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @gallery }
    end
  end

  # GET /galleries/1/edit
  def edit
    @gallery = Gallery.find(params[:id])
  end

  # POST /galleries
  # POST /galleries.json
  def create
    @gallery = Gallery.new(params[:gallery])

    respond_to do |format|
      if @gallery.save
        format.html { redirect_to galleries_path, :notice => 'Gallery was successfully created.' }
        format.json { render :json => @gallery, :status => :created, :location => @gallery }
      else
        format.html { render :action => "new" }
        format.json { render :json => @gallery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /galleries/1
  # PUT /galleries/1.json
  def update
    @gallery = Gallery.find(params[:id])

    respond_to do |format|
      if @gallery.update_attributes(params[:gallery])
        format.html { redirect_to galleries_path, :notice => 'Gallery was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @gallery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /galleries/1
  # DELETE /galleries/1.json
  def destroy
    @gallery = Gallery.find(params[:id])
    @gallery.destroy

    respond_to do |format|
      format.html { redirect_to galleries_url }
      format.json { head :no_content }
    end
  end  
  
  def add_pictures_to_gallery
    gal = Gallery.find(params[:gallery_id])
  
    pictures = params[:pictures]
    if pictures
      i=0
      Categorization.delete_all(:gallery_id => ["gallery_id = ?", gal.id])
      pictures.each do |p|
        pic = Picture.find(p)
        Categorization.create(:gallery => gal, :picture =>pic, :order => i) 
        i=i+1
      end
    end
    redirect_to galleries_url
  end
  
end
