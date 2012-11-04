class Admin::PicturesController < ApplicationController
  before_filter :verify_admin

  # GET /pictures
  # GET /pictures.json
  def index

    if params.has_key?('last')
      @pictures = Picture.where(' id not in (SELECT picture_id from categorizations)')
    else
      @pictures = Picture.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pictures }
    end
  end

  # GET /pictures/1
  # GET /pictures/1.json
  def show
    @picture = Picture.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @picture }
    end
  end

  # GET /pictures/new
  # GET /pictures/new.json
  def new
    @picture = Picture.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @picture }
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
        format.html { redirect_to @picture, notice: 'Picture was successfully created.' }
        format.json { render json: @picture, status: :created, location: @picture }
      else
        format.html { render action: "new" }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pictures/1
  # PUT /pictures/1.json
  def update
    @picture = Picture.find(params[:id])

    respond_to do |format|
      if @picture.update_attributes(params[:picture])
        format.html { redirect_to @picture, notice: 'Picture was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
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
      
      redirect_to admin_pictures_path+'?last'
  end
  
  def upload_picture(upload_file)
     uploaded_io = upload_file
      filename = uploaded_io.original_filename
      upload_dir=Rails.root.join('public/pictures')

      unless File.directory?(upload_dir)
        Dir.mkdir(upload_dir)
      end
      File.open(Rails.root.join(upload_dir, filename), 'wb') do |file|
        file.write(uploaded_io.read)
      end
      md5 = Digest::MD5.hexdigest(File.read(File.join(upload_dir, filename)))
      md5_filename = md5 + File.extname(filename) 

      File.rename(File.join(upload_dir, filename) , File.join(upload_dir, md5_filename))

      thumb = resize upload_dir, md5_filename

      thumb.write(File.join(upload_dir, 'thumb-'+filename))

      md5_thumb = Digest::MD5.hexdigest(File.read(Rails.root.join(upload_dir, 'thumb-'+filename)))
      md5_thumb_filename = md5_thumb + File.extname(filename)
      File.rename(File.join(upload_dir, 'thumb-'+filename) , File.join(upload_dir, md5_thumb_filename))

      Picture.create(
          url:  Rails.application.config.action_controller.asset_host.to_s + '/pictures/' + md5_filename, 
          thumb_url: Rails.application.config.action_controller.asset_host.to_s + '/pictures/' + md5_thumb_filename, 
          thumb_width: thumb.columns,
          thumb_height: thumb.rows,
          title: "test title", 
          caption: "test caption" )

   end
  

  def resize(upload_dir, filename)
    img_orig = Magick::Image.read(File.join(upload_dir, filename)).first
    width_orig = img_orig.columns
    height_orig = img_orig.rows
  
    new_h = 140
    new_w = width_orig * new_h / height_orig
    if (new_w < 220)
      new_w = 220
      new_h = height_orig * new_w / width_orig
    end

    img_orig.resize(new_w,new_h)
  end

end
