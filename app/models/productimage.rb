######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################

class Productimage < ActiveRecord::Base
  file_column :image, :magick => { 
          :versions => {"thumb" => "32x32", "medium" => "100x75", "large"=>"300x200"}
          
          # fixed sizes
          # :versions => {"thumb" => "32x32", "medium" => "100x75!", "large"=>"300x200!"}
  }
  validates_file_format_of :image, :in => ["gif", "jpg", "png"]
  validates_filesize_of :image, :in => 1.kilobytes..5000.kilobytes
  def product
    product = Product.find(self.product_id)
  end  
end
