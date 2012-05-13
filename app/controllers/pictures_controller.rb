class PicturesController < ApplicationController
  before_filter :verify_admin

  # GET /pictures
  # GET /pictures.json
  def index
    @pictures = Picture.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @pictures }
    end
  end

  # GET /pictures/1
  # GET /pictures/1.json
  def show
    @picture = Picture.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @picture }
    end
  end

  # GET /pictures/new
  # GET /pictures/new.json
  def new
    @picture = Picture.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @picture }
    end
  end

  # GET /pictures/1/edit
  def edit
    @picture = Picture.find(params[:id])
  end

  # POST /pictures
  # POST /pictures.json
  def create
    @picture = Picture.new(params[:picture])

    respond_to do |format|
      if @picture.save
        format.html { redirect_to @picture, :notice => 'Picture was successfully created.' }
        format.json { render :json => @picture, :status => :created, :location => @picture }
      else
        format.html { render :action => "new" }
        format.json { render :json => @picture.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pictures/1
  # PUT /pictures/1.json
  def update
    @picture = Picture.find(params[:id])

    respond_to do |format|
      if @picture.update_attributes(params[:picture])
        format.html { redirect_to @picture, :notice => 'Picture was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @picture.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pictures/1
  # DELETE /pictures/1.json
  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy

    respond_to do |format|
      format.html { redirect_to pictures_url }
      format.json { head :no_content }
    end
  end
  
  def upload
      @final_filenames = []
    
      params[:uploads].each do |u|
        
        @final_filenames << upload_picture(u)
      end
      
      render 'upload.html.erb'
  end
  
  def upload_picture(upload_file)
     uploaded_io = upload_file
      filename = uploaded_io.original_filename
      upload_dir='/tmp/upload-pictures'
      unless File.directory?(upload_dir)
        Dir.mkdir(upload_dir)
      end
      File.open(Rails.root.join(upload_dir, filename), 'w') do |file|
        file.write(uploaded_io.read)
      end
      md5 = Digest::MD5.hexdigest(File.read(Rails.root.join(upload_dir, filename)))
      final_filename = md5 +'-'+ filename
     # AWS::S3::S3Object.store(final_filename, open(Rails.root.join(upload_dir, filename)), 'mootmoot')
   end
  
end
