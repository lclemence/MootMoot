class Picture < ActiveRecord::Base
  belongs_to :gallery
  attr_accessible :caption, :title, :url, :gallery_id, :thumb_url
end
