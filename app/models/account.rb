######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################

class Account < ActiveRecord::Base
  
  # for all account types

  validates_format_of :account_type,:with => /1|0/,:message => "Account type value is invalid"
  
  validates_length_of :username, :in => 3..18, :message => "length should be between 3 and 18"
  validates_uniqueness_of :username
  validates_format_of :username,:with => /^\w+$/,:message => "invalid"
 
  validates_length_of :contact_name, :in => 5..50, :message => "length should be between 5 and 50"
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/
  validates_length_of :email, :in => 5..50, :message => "length should be between 5 and 50"
  #validates_length_of :postcode, :in => 4..8, :message => "length should be between 4 and 8"
  
  validates_length_of :password, :in => 3..18, :message => "length should be between 3 and 18"
  validates_confirmation_of  :password, :message => "doesn't match retyped password"
  
  #validates_length_of :phone, :in => 7..25, :message => "length should be between 7 and 25"
  validates_format_of :suspended,:with => /1|0/,:message => "Suspended value is invalid"
  validates_length_of :country, :in => 2..25, :message => "length should be between 2 and 25"
  validates_format_of :price_level_id,:with => /1|2|3|4|5|6|7|8|9|0/,:message => "Price level is invalid"
  validates_format_of :special_offers,:with => /1|0/,:message => "Special offers value is invalid"
  
  
  def try_to_login
		Account.login(self.username, self.password)
	end
	
	def self.login(username, password)
		find(:first, :conditions=>["username = ? AND password = ?", username, password])
	end
  
  def discount_percentage
    size = Pricelevel.find(:all, :conditions=>['id = ?', self.price_level_id]).size
    if size > 0
      pricelevel = Pricelevel.find(self.price_level_id)
      return pricelevel.discount_percentage
    else
      return 0
    end  
  end
  
  def pricelevel
    Pricelevel.find(:all, :conditions=>['id = ?', self.price_level_id])
  end
  
  def orders
    return Order.find(:all, :conditions=>["customer_id = ?", self.id], :order=>'id DESC')
  end  
 
  
protected
  def validate
    # for dealer account
    if self.account_type == 0
      errors.add(:business_address, "length should be between 5 characters and 200 characters") unless business_address.length >= 5 and business_address.length <= 200
      errors.add(:business_name, "length should be between 5 characters and 200 characters") unless business_name.length >= 5 and business_name.length <= 50
      
    end
    
    # for direct buyer account
    if self.account_type == 1
      errors.add(:business_address, "or Home address length should be between 5 characters and 200 characters") unless business_address.length >= 5 and business_address.length <= 200
    end  
    
  end  
end
