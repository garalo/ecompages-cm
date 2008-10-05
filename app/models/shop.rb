######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################

## TODO: Admin function for store information

class Shop < ActiveRecord::Base
  
  def self.tax_code_name
    Shop.find(1).tax_name
  end
  
  def self.tax_rate
    Shop.find(1).tax_rate
  end
  
  def self.is_tax_incl_when_adding_new_product
    Shop.find(1).is_tax_incl_when_adding_new_product
  end
  
  ## A true/false version for 'is_tax_incl_when_adding_new_product'
  def self.is_tax_incl
    if Shop.find(1).is_tax_incl_when_adding_new_product == 1
      true
    else
      false
    end
  end
  
  def self.def_store
    Shop.find(1)
  end
  
  def self.version
    Shop.find(1).version
  end
  
  def self.allow_donation
    Shop.find(1).allow_donation
  end  
  
  def self.header_message
    Shop.find(1).header_message
  end
  
  def self.powered_by_message
    "Powered by EcomPages " + self.version
  end
  
  def self.shop_name
    Shop.find(1).shop_name
  end 
  
  def self.def_template_name
    Shop.find(1).def_template_name
  end
  
  def self.admin_email
    Shop.find(1).admin_email
  end
  
  def self.company_name
    Shop.find(1).company_name
  end
  
  def self.business_address
    Shop.find(1).b_addr
  end
  
  def self.business_phone
    Shop.find(1).b_phone
  end
  
  def self.business_mobile
    Shop.find(1).b_mobile
  end
  
  def self.business_bank_account
    Shop.find(1).b_bank_acct
  end
  
  def self.business_website
    Shop.find(1).b_website
  end
  
  
  #
  def self.install_dir_name
    if Shop.find(1).install_dir_name.blank?
      ""
    else
      Shop.find(1).install_dir_name
    end
  end
end
