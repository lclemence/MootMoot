class Gallery < ActiveRecord::Base
  attr_accessible :name
  has_many :categorizations
  has_many :pictures , :through => :categorizations, :order => "pictures.id ASC"
  has_many :child, :class_name => "Gallery",
    :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "Gallery"
end
