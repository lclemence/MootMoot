# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
Constant.create(:name => 'project', :value => 'Julien Pellet')
Constant.create(:name => 'minwidth_thumb', :value => '200')
Constant.create(:name => 'minheight_thumb', :value => '140')
Constant.create(:name => 'cdn_base_url', :value => 'xxx.cloudfront.com')
Constant.create(:name => 'cdn_key_id', :value => 'cdn_key')
Constant.create(:name => 'cdn_key_secret', :value => 'cdn_secret')


Gallery.delete_all
gal = Gallery.create(:name => "WELLINGTON")
Gallery.create(:name => "Nature")
Gallery.create(:name => "Portrait")
Gallery.create(:name => "Fine Art")

User.new({:email => "toto@gmail.com", :password => "password", :password_confirmation => "password" }).save

password = Devise.friendly_token[0,20]
User.new({:email => "pelletj@gmail.com", :password => password, :password_confirmation => password }).save 
User.find_by_email("pelletj@gmail.com").add_role :admin
#Role.create({:name => "admin"}).save

repository = "/home/jpellet/DEV/julienpellet.com-php/gallery/all"
#repository = "/home/clemence/Pictures/all"
Categorization.delete_all
Picture.delete_all
i=0
Dir.glob(repository+"/**/*").each do |file|
  if !File.directory?(file)

     cdn_filename = file.gsub(repository,"all")

    if !cdn_filename['thumb']
      thumb_url = cdn_filename.gsub('images','thumbs')
       
      pic = Picture.create(
        :url => cdn_filename, 
        :thumb_url => thumb_url, 
        :title => "test title", 
        :caption => "test caption", 
        :thumb_width => "220",
        :thumb_height => "140", 
        :thumb_x => "0",
        :thumb_y => "0")
     
      Categorization.create(:gallery => Gallery.all.sample, :picture =>pic, :order => i)
      #Categorization.create(:gallery_id => gal.id, :picture_id =>pic.id)
      i=i+1
    end
  end
end


