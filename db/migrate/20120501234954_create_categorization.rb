class CreateCategorization < ActiveRecord::Migration
  def up
     create_table :categorizations do |t|
        t.integer :gallery_id
        t.integer :picture_id
        t.integer :order
        t.timestamps
      end
  end

  def down
    remove_column :pictures, :gallery_id
    remove_index :pictures, :column => :gallery_id
  end
end
