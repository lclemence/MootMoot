class ConstantsController < ApplicationController
  # GET /constants
  # GET /constants.json
  def index
    @constants = Constant.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @constants }
    end
  end

  # GET /constants/1
  # GET /constants/1.json
  def show
    @constant = Constant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @constant }
    end
  end

  # GET /constants/new
  # GET /constants/new.json
  def new
    @constant = Constant.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @constant }
    end
  end

  # GET /constants/1/edit
  def edit
    @constant = Constant.find(params[:id])
  end

  # POST /constants
  # POST /constants.json
  def create
    @constant = Constant.new(params[:constant])

    respond_to do |format|
      if @constant.save
        format.html { redirect_to @constant, :notice => 'Constant was successfully created.' }
        format.json { render :json => @constant, :status => :created, :location => @constant }
      else
        format.html { render :action => "new" }
        format.json { render :json => @constant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /constants/1
  # PUT /constants/1.json
  def update
    @constant = Constant.find(params[:id])

    respond_to do |format|
      if @constant.update_attributes(params[:constant])
        format.html { redirect_to @constant, :notice => 'Constant was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @constant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /constants/1
  # DELETE /constants/1.json
  def destroy
    @constant = Constant.find(params[:id])
    @constant.destroy

    respond_to do |format|
      format.html { redirect_to constants_url }
      format.json { head :no_content }
    end
  end
end
