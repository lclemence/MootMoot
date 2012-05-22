class AdminController < ApplicationController
  before_filter :verify_admin

  def index
  end
  
  def editparams
     constants = params[:value_constants]
     Constant.delete_all
     constants.each do |k,v|
       Constant.create(:name => k, :value => v.first)
     end
     redirect_to admin_path
  end
end
