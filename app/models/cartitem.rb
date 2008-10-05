######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################

class CartItem
  def initialize(product_id, quantity)
    @product_id = product_id
    @quantity = quantity
  end
	
  def product_id
    return @product_id
  end
	
  def quantity
    return @quantity
  end  
	
  def increase_quantity
    @quantity += 1
  end
	
  def decrease_quantity
    @quantity -= 1 if @quantity > 1
  end      
	  
end  