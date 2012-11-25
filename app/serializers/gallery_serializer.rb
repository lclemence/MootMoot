class GallerySerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :pictures, embed: :objects
  has_many :child, embed: :objects
end
