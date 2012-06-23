class Gallery < ActiveRecord::Base
  attr_accessible :name
  has_many :categorizations
  has_many :pictures , :through => :categorizations, :order => "pictures.id ASC"
end
