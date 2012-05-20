class AddThumbXToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :thumb_x, :integer
    add_column :pictures, :thumb_y, :integer
  end
end
