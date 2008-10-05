######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################

class Orderitem < ActiveRecord::Base
  
  def product
    Product.find(self.product_id)
  end  
end
