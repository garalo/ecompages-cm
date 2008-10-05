######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################

## TODO: Code clear
class ShopController < ApplicationController

  layout "adminlogin"
  
  def config
    @page_title = "Store Config"
    
    
    session[:account_id] = nil
    session[:admin_id] = nil
    session[:cart] = nil
    if request.get?
      
      # check if the Shops table has been setted up
      
      if Shop.find(:all).size == 0
        # insert values
        shop = Shop.new
        shop.shop_name = "EcomPages demo store"
        shop.header_message = "This is a demo header message"
        shop.version = "2.0.2"
        shop.allow_donation = 0
        shop.def_template_name = "default"
        shop.tax_name = "TAX"
        shop.tax_rate = 0
        shop.is_tax_incl_when_adding_new_product = 1
        shop.install_dir_name = ""
        shop.admin_email = "admin@your-store.com"
        shop.company_name = "Your company name"
        shop.b_addr = "123 Abc St, XYZ, A-Country"
        shop.b_phone = "01-1234567"
        shop.b_mobile = "234-5678987"
        shop.b_bank_acct = "12-1234-123456-00"
        shop.b_website = "http://www.your-domain.com"
        
        shop.save
      
      end
      
      if Category.find(:all).size == 0
        #
        
        category = Category.new
        category.name = "Top Category"
        category.p_id = 0
        category.level_order = 1
        category.label = ""
        category.level_num = 1
        category.save
        
        category = Category.new
        category.name = "Category 1"
        category.p_id = 1
        category.level_order = 1
        category.label = ""
        category.level_num = 101
        category.save
        
        category = Category.new
        category.name = "Category 2"
        category.p_id = 1
        category.level_order = 1
        category.label = ""
        category.level_num = 102
        category.save
      end
      
      if Administrator.find(:all).size == 0
        admin = Administrator.new
        admin.username = "admin"
        admin.password = "admin"
        admin.level = 1
        admin.save
      end
      
      if Page.find(:all).size == 0
        page = Page.new
        page.title = "Terms and Conditions"
        page.value = "Edit me from Admin -> Content Management"
        page.created_at = Time.now
        page.save
        
        page = Page.new
        page.title = "About Us"
        page.value = "Edit me from Admin -> Content Management"
        page.created_at = Time.now
        page.save
        
        page = Page.new
        page.title = "Product Refunds and Specifications"
        page.value = "Edit me from Admin -> Content Management"
        page.created_at = Time.now
        page.save
        
        page = Page.new
        page.title = "Contact Us"
        page.value = "Edit me from Admin -> Content Management"
        page.created_at = Time.now
        page.save
        
      end
      
      if Freightoption.find(:all).size == 0
        f = Freightoption.new
        f.name = "Small Bag"
        f.price = 5
        f.note = "A $5 bag"
        f.save
      end
      
      if Product.find(:all).size == 0
        p = Product.new
        
        p.time_created = Time.now
        p.price = 100
        p.details = "Edit me from Admin -> Product Manager"
        p.delivery = 1
        p.stock_level = 5
        p.title = "Product title"
        p.category_id = 2
        p.views = 1
        p.donation = 0
        p.labels = ""
        p.freightoption_id = 1
        p.save
        
      end
      
      
      
      if Pricelevel.find(:all).size == 0
        pl = Pricelevel.new
        pl.title = "Retail Account"
        pl.discount_percentage = 0
        pl.note = "Retail Account"
        pl.save
      end
      
      if Account.find(:all).size == 0
        
        a = Account.new
        a.username = "demo"
        a.contact_name = "De Mo"
        a.email = "demo@demo.com"
        a.password = "demo"
        a.note = "This is a demo account"
        a.business_name = "Buz name"
        a.phone = "1234567"
        a.cellphone = "23456789"
        a.country = "New Zealand"
        a.shipping_address = "123 St, ABC city"
        a.business_address = "123 St, ABC city"
        a.suspended = 0
        a.time_created = Time.now
        a.special_offers = 1
        a.agree_terms = 1
        a.postcode = "1234"
        a.account_type = 1
        a.save
      end
      
    end
      flash[:notice] = "Installation completed!"
   
  end
end
