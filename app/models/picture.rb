class Picture < ActiveRecord::Base
  has_many :gallery , :through => :categorizations
  has_many :categorizations
  attr_accessible :caption, :title, :url, :thumb_url, :thumb_width, :thumb_height, :thumb_x, :thumb_y
end
