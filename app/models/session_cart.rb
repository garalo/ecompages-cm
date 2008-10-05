######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################

require 'cartitem'
require 'shop'

class SessionCart
  def initialize(account = nil)
    @account = account
    @items = []
  end
  
  def add_product(product_id)
    has = false
    for itm in @items
      if itm.product_id == product_id
        # quantity + 1
        itm.increase_quantity
        has = true
      end
    end
    # create a new cartitem object
    if has != true
      newitem = CartItem.new(product_id, 1)
      @items << newitem
    end  
    
  end
  
  def items
    return @items
  end  
  
  def size
    sum = 0
    for item in @items
      sum += item.quantity
    end
    return sum
  end
  
  def clear
    @items = []
  end
  
  def delete_product(product_id)
    newitems = []
    
    for item in @items
      newitems << item if item.product_id != product_id
    end
    @items = newitems
    newitems = nil 
  end
  
  def decrease_quantity(product)
    for item in @items
      if item.quantity >= 2
        item.decrease_quantity if item.product_id == product.id
      end  
    end
  end
  
  def increase_quantity(product)
    for item in @items
      item.increase_quantity if item.product_id == product.id
    end
  end
  
  def sub_total
    # Acct
    sum = 0.0
    for item in @items
      p = Product.find(item.product_id)
      sum += (p.price_for_account(@account) * item.quantity.to_f)
      
    end
    #sum = sum * (1 - @discount_percentage.to_f / 100)
    return sum
  end
  
  def tax_amount
    
    if Shop.is_tax_incl
      return sub_total.to_f / (Shop.tax_rate + 1)
    else
      return sub_total.to_f * (Shop.tax_rate / 100)
    end
  end
  
  def total
    
    if Shop.is_tax_incl
      sub_total
    else
      sub_total + tax_amount
    end
    
  end          
end  