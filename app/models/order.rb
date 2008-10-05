######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################

class Order < ActiveRecord::Base
  
  def total_donation
    sum = 0.0
    for item in items
      sum += (item.product.donation * item.quantity)
    end
    return sum
  end  
  
  def customer
    Account.find(self.customer_id)
  end
  
  def email
    self.customer.email
  end  
  
  def items
    Orderitem.find(:all, :conditions=>["order_id = ?", self.id])
  end
  
  def clear_items
    items_to_remove = Orderitem.find(:all, :conditions=>["order_id = ?", self.id])
    for itm in items_to_remove
      itm.destroy
    end  
  end
  
  def before_destroy
    clear_items
  end
  
  def sub_total
    sum = 0.0
    for item in items
      sum += (item.price_in_order * item.quantity)
    end
    #sum = sum * (1 - @discount_percentage.to_f / 100)
    return sum
  end
  
  def tax
    
    if Shop.is_tax_incl
      return (sub_total/(1 + Shop.tax_rate))
    else
      return sub_total.to_f * (Shop.tax_rate/100)
    end
  end
  
  def total
    if Shop.is_tax_incl
      return sub_total
    else
      return sub_total + tax
    end
  end
  
  def total_with_freight
    total + self.suggested_freight_cost
  end
  
  
  #
  def self.number_of_orders(status)
    Order.find_all_by_status(status).size
  end  
end
