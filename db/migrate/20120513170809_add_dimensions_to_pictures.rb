class AddDimensionsToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :thumb_width, :integer
    add_column :pictures, :thumb_height, :integer
  end
end
