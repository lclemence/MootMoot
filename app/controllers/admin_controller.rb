class AdminController < ApplicationController
  before_filter :verify_admin

  def index
  end
end
