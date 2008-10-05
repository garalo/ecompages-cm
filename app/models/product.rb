######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################

class Product < ActiveRecord::Base
  
  validates_length_of :title, :in => 1..200, :message => "length should be between 1 and 200"
  
  def images
    return Productimage.find_all_by_product_id(self.id)
  end
  
  def category
    size = Category.find(:all, :conditions=>["id = ?", self.category_id]).size
    
    if size > 0
      return Category.find(self.category_id)
    else
      #
      self.category_id = 1
      self.save
      return Category.find(1)
    end    
  end
  
  def freightoption
    size = Freightoption.find(:all, :conditions=>["id = ?", self.freightoption_id]).size
    
    if size > 0
      return Freightoption.find(self.freightoption_id)
      #return "#{f.name} (#{number_to_currency f.price})"
    else
      #
      self.freightoption_id = 1
      self.save
      return Freightoption.find(1)
    end
  end
  
  def price_for_account(account)
   
    price = self.price
    
    return price if account.nil? == true
    
    pricelevelsmatrix = Pricelevelsmatrix.find(:first, 
          :conditions=>["pricelevel_id = ? and product_id = ?", 
            account.price_level_id, 
            self.id])
    if pricelevelsmatrix != nil
      price = pricelevelsmatrix.price
    end
    
    return price
  end  
  
end
