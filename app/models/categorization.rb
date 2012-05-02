class Categorization < ActiveRecord::Base
	  attr_accessible :gallery, :picture, :order
	  belongs_to :gallery
	  belongs_to :picture
end