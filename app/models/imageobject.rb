class Imageobject < ActiveRecord::Base
  file_column :image, :magick => { 
          :versions => {"thumb" => "40x30", "medium" => "400x300", "large"=>"640x480"}
  }
end
