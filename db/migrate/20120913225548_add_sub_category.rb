class AddSubCategory < ActiveRecord::Migration
  def up
	add_column :galleries, :parent_id, :integer, :null => true
  	
  	 #add a foreign key
    #execute <<-SQL
     # ALTER TABLE galleries ADD CONSTRAINT fk_galleries_parent FOREIGN KEY (parent_id) REFERENCES galleries(id)
      # SQL
  end

  def down
  	
  	remove_column :galleries, :parent
  	
  	#execute <<-SQL
    #  ALTER TABLE galleries
     #   DROP FOREIGN KEY fk_galleries_parent
    #SQL
  end
end
