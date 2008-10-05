######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################


## This controller contains methods for the 
## front-end functions

class GoController < ApplicationController
  
  # Set to default layout file if layout is nil
  layout "#{Shop.def_template_name}"
  # layout "lightblue"
  
  ###########################
  ####  Render actions   ####
  ###########################
  
  def index
    
    session[:label] = "index"
    
    @page_title = "Home"
    @account = getAccount()
    
    session[:sort] = "id DESC" if session[:sort] == nil
    session[:sort] = 'price' if params[:sort] == "lprice"
    session[:sort] = 'id DESC' if params[:sort] == "latest"
    session[:sort] = 'price DESC' if params[:sort] == "hprice"
    session[:sort] = 'title' if params[:sort] == "title"
    
    @products = Product.paginate(:order=> session[:sort], 
      :per_page => 16, 
      :page=>params[:page],
      :conditions => ["id != ?", 0])
    
    @current_page_number = params[:page]
    @current_page_number = 1 if @current_page_number.blank?
    
    render(:file => "#{RAILS_ROOT}/app/views/templates/#{Shop.def_template_name}/frontend/#{action_name}.html.erb", 
      :layout => true)
  end
  
  def page
    @page = Page.find(params[:id])
    @page_title = @page.title
    @account = getAccount()
    render(:file => "#{RAILS_ROOT}/app/views/templates/#{Shop.def_template_name}/frontend/#{action_name}.html.erb", 
      :layout => true)
  end
  
  def pages
    @account = getAccount()
    session[:label] = "blog"
    
    @pages = Page.find(:all, :conditions=>["id > 4"], :order=>"id DESC")
    render(:file => "#{RAILS_ROOT}/app/views/templates/#{Shop.def_template_name}/frontend/#{action_name}.html.erb", 
      :layout => true)
  end
  
  def update_account_info
    if request.post?
      contact_name = params[:account][:contact_name]
      b_addr = params[:account][:business_address]
      s_addr = params[:account][:shipping_address]
      email = params[:account][:email]
      
      account = getAccount()
      
      err = "Updated."
      
      if account.update_attribute('contact_name', contact_name)
        
      else
        err = "Contact Name couldn't be updated."
      end
      
      if account.update_attribute('business_address', b_addr)
        
      else  
        err = "Address couldn't be updated."
      end
      
      if account.update_attribute('shipping_address', s_addr)
        
      else  
        err = "Shipping Address couldn't be updated."
      end
      
      if email =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
        account.update_attribute('email', email)
      else  
        err = "Email couldn't be updated."
      end
      
      flash[:notice] = err
      
      redirect_to(:action=>'account')
      
    end
    
    if request.get?
      redirect_to(:action=>'account')
    end
  end
  
  def account
    session[:label] = "my-acct"
    @page_title = "My Account"
    @account = getAccount()
    
    if @account.blank?
      flash[:notice] = "Please login."
      redirect_to :action=>'login', :controller=>'go'
    else
      # An account holder
      @orders = @account.orders
      
      render(:file => "#{RAILS_ROOT}/app/views/templates/#{Shop.def_template_name}/frontend/#{action_name}.html.erb", 
        :layout => true)
    end
    
  end
  
  
  def invoice
    
    @account = getAccount()
    
    if @account.blank?
      flash[:notice] = "Please login."
      redirect_to :action=>'login', :controller=>'go'
    else
      # An account holder
      @order = Order.find(params[:id])
      @page_title = "View Invoice #: " + params[:id] 
      if @order.customer_id == @account.id
        render(:file => "#{RAILS_ROOT}/app/views/templates/#{Shop.def_template_name}/frontend/#{action_name}.html.erb", 
          :layout => "invoice")
      else  
        render :layout=>"invoice", :inline=>"<h2><font color='red'>Sorry, you are trying to view an invalid order.</font></h2>"
      end
    end
    
#  rescue
#    ## TODO: Error code explaination page
#    redirect_to :action=>'error_page'
  end    
  
  
  def view_cart
    #
    @account = getAccount()
    @cart = session[:cart]
    render(:file => "#{RAILS_ROOT}/app/views/templates/#{Shop.def_template_name}/frontend/#{action_name}.html.erb", 
      :layout => true)
  end
  
  
  ## This is a very basic search function, not designed
  ## for heavy load
  
  ## TODO: re-design search action
  def search
    
    @account = getAccount()
    
    session[:sort] = "id DESC" if session[:sort] == nil
    session[:sort] = 'price' if params[:sort] == "lprice"
    session[:sort] = 'id DESC' if params[:sort] == "latest"
    session[:sort] = 'price DESC' if params[:sort] == "hprice"
    session[:sort] = 'title' if params[:sort] == "title"
    
    # request from search form
    if request.post?
      params[:darken] = false
      session[:label] = ""
      
      @page_title = "Search"
      if params[:search][:query].blank?
        redirect_to :action=>'index', :controller=>'go'
      else
        
        query = params[:search][:query]


        #@product_pages, @products = paginate(:product, :conditions => ["match(details,title) against  (?)", query], :order=> session[:sort])

        ##########
        q = query
        q = query.gsub(/\s/, ' , ')

        q = "%"+q+"%"

        @products = Product.paginate(:order=> session[:sort], 
          :per_page => 10, 
          :page=>params[:page],
          :conditions => ["title like ? OR details like ? OR labels like ?", q,q,q])
        ##########

        @header = "Product(s) for your query: '" + query + "'"

        render(:file => "#{RAILS_ROOT}/app/views/templates/#{Shop.def_template_name}/frontend/#{action_name}.html.erb", 
          :layout => true)
      end    
    end
    
    
    # request from menu
    if request.get?
      
      params[:darken] = true
      
      if params[:label].blank?
        @page_title = session[:label].to_s
        query = session[:label].to_s 
        #session[:label] = query
      else
        @page_title = params[:label].to_s
        query = params[:label].to_s 
        session[:label] = query 
      end    
      
      q = "%" + query + "%"
      q = q.downcase
     
      @products = Product.paginate(:order=> session[:sort], 
        :per_page => 8, 
        :page=>params[:page],
        :conditions => ["labels like ?", q])
      
      @header = "" + query + ""
      
      render(:file => "#{RAILS_ROOT}/app/views/templates/#{Shop.def_template_name}/frontend/#{action_name}.html.erb", 
        :layout => true)
    end  
    
  end
    
  
  
  def order_has_been_placed
    session[:label] = ""
    @page_title = "Thank You!"
    @account = getAccount()
    #
    session[:cart].clear
    session[:freight_cost] = 0.0
    session[:freight_suggests] = "None."
    
    render(:file => "#{RAILS_ROOT}/app/views/templates/#{Shop.def_template_name}/frontend/#{action_name}.html.erb", 
      :layout => true)
  end  
    
  
  def product
    
    session[:label] = ""
    
    session[:product_layout] = "def" if session[:product_layout].blank?
    
    session[:product_layout] = "classic" if params[:layout] == "classic"
    session[:product_layout] = "def" if params[:layout] == "def"
    
    @product = Product.find(params[:id])
	  
    session[:last_product_id_viewed] = @product.id
	  
    @account = getAccount()
    
    @product.update_attribute("views", @product.views + 1)
    
    @page_title = "Product - " + @product.title

    @similar_products = Product.find(:all, :conditions=>["category_id = ? and id != ?", @product.category_id, @product.id], :limit=>8)

    render(:file => "#{RAILS_ROOT}/app/views/templates/#{Shop.def_template_name}/frontend/#{action_name}.html.erb", 
      :layout => true)
  end
	
  def category
    if params[:id].to_i == 1
      redirect_to :action=>'index'
    else
  
      session[:label] = ""
      @account = getAccount()
    
      session[:sort] = "id DESC" if session[:sort] == nil
      session[:sort] = 'price' if params[:sort] == "lprice"
      session[:sort] = 'id DESC' if params[:sort] == "latest"
      session[:sort] = 'price DESC' if params[:sort] == "hprice"
      session[:sort] = 'title' if params[:sort] == "title"
    
      @category = Category.find(params[:id])
      session[:category_id] = @category.id
     
    
      @page_title = @category.name
    
      @products = Product.paginate(:order=> session[:sort], 
        :per_page => 10,
        :conditions=>["category_id = ? or category_id_fix_1 = ? or category_id_fix_2 = ?", @category.id, @category.id, @category.id],
        :page=>params[:page])
                              
      render(:file => "#{RAILS_ROOT}/app/views/templates/#{Shop.def_template_name}/frontend/#{action_name}.html.erb", 
        :layout => true)
    end        
  end  
  
  
  def login
    @page_title = "User Login"
    session[:label] = "login"
    if request.get?
      @page_title = "Login"
		  
      session[:account_id] = nil
      # session[:cart] = nil
      session[:account_type] = nil
      @account = nil
			
      render(:file => "#{RAILS_ROOT}/app/views/templates/#{Shop.def_template_name}/frontend/#{action_name}.html.erb", 
        :layout => true)
      
    else
      @account = Account.new(params[:account])
      logged_in_account = @account.try_to_login
      if logged_in_account
        if logged_in_account.suspended != 1
          session[:account_id] = logged_in_account.id
			    
          # TODO: BUG: if an account's price level has been changed while
          #   the account is in session. The sub_total of Class Cart will be
          #   incorrect.
          session[:cart] = SessionCart.new(logged_in_account) if session[:cart].nil?
			    
          if session[:should_remember_product_id]
            redirect_to(:action => "product", :controller =>"go", :id=>session[:last_product_id_viewed])
          else
            redirect_to(:action => "index", :controller =>"go")
          end
			    
        else
          flash[:notice] = "Your account is not actived."
          redirect_to(:action => "login", :controller =>"go")
        end  
      else
        flash[:notice] = "Invalid user/password combination."
        redirect_to(:action => "login", :controller =>"go")
      end
    end
  end
	
  # This actually is a 'No Render action'
  def logout
    @page_title = "Logged Out"
    session[:account_id] = nil
    session[:should_remember_product_id] = false
	  
    flash[:notice] = "Logged out."
    redirect_to :action=>'login', :controller=>'go'
  end
	

  def registration
    session[:label] = "registration"
    
    if not params[:type].blank?
      if params[:type] == "dealer"
        session[:account_type] = 0
      else
        session[:account_type] = 1
      end
      redirect_to :action=>'new', :controller=>'accounts'
  	  
    else
      session[:account_type] = nil
      render(:file => "#{RAILS_ROOT}/app/views/templates/#{Shop.def_template_name}/frontend/#{action_name}.html.erb", 
        :layout => true)
    end
  end
	
	
  ## Methods for Default Pages ##
  
  def contact_us
    #
    if request.get?
      @page_title = "Contact Us"
      @page = Page.find_by_title(@page_title)
    end
	  
    if request.post?
      # TODO
      pass = true
      error = "Please check the name, email and note fields are not empty."
	    
      name = params[:contact][:name] 
      email = params[:contact][:email]
      phone = params[:contact][:phone]
      note = params[:contact][:note]
	    
      pass = false if name.blank?
      pass = false if email.blank?
      pass = false if note.blank?
	    
	    
      #email = OrderMailer.create_sent(params[:contact][:name],params[:contact][:email],params[:contact][:phone],params[:contact][:note])
      #email.set_content_type("text/html")
      
      if pass
        OrderMailer.deliver_formmessage(name,email,phone,note)
        flash[:notice] = "Thank you! Your message has been sent, we will contact you shortly."
        redirect_to :action=>'contact_us', :controller=>'go'
      else
        flash[:notice] = error
        redirect_to :action=>'contact_us', :controller=>'go'
      end  
    end  
    render(:file => "#{RAILS_ROOT}/app/views/templates/#{Shop.def_template_name}/frontend/#{action_name}.html.erb", 
      :layout => true)
  end
	
	
  def about_us
    #
    @page_title = "About Us"
    @page = Page.find_by_title(@page_title)
    render(:file => "#{RAILS_ROOT}/app/views/templates/#{Shop.def_template_name}/frontend/#{action_name}.html.erb", 
      :layout => true)
  end
	
  def terms_conditions
    #
    @page_title = "Terms and Conditions"
    @page = Page.find_by_title(@page_title)
    render(:file => "#{RAILS_ROOT}/app/views/templates/#{Shop.def_template_name}/frontend/#{action_name}.html.erb", 
      :layout => true)
  end
	
  def product_refunds_specifications
    #
    @page_title = "Product Refunds and Specifications"
    @page = Page.find_by_title(@page_title)
    render(:file => "#{RAILS_ROOT}/app/views/templates/#{Shop.def_template_name}/frontend/#{action_name}.html.erb", 
      :layout => true)
  end 
  ## END of methods for Default Pages ##
	
  ###########################
  ### Render actions END  ###
  ###########################
	
	
	
	
  
  ###########################
  #### No Render actions ####
  ###########################
  
  def change_email_settings
    if request.post?
      account = getAccount()
      value = params[:account][:special_offers].to_i
      account.update_attribute("special_offers", value)
      
      flash[:notice] = "Changes Saved."
      redirect_to :action=>'account', :controller=>'go'
    else
      redirect_to :action=>'account', :controller=>'go'
    end    
  end  
  
  # Show the 'large' version of image of a product
  # This method should be moved to a separate controller
  def view_image
    
    @image = Productimage.find(params[:id])
    #@page_title = "Large Image - " + @image.product.title
    @page_title = "View Large Image"
    render(:file => "#{RAILS_ROOT}/app/views/templates/#{Shop.def_template_name}/frontend/#{action_name}.html.erb", 
      :layout => false)
  rescue
    render :layout=>nil, :inline=>"ERROR CODE: 8807."
  end
  
  # Allowing account holder changing password
  def change_password
    if request.post?
      @account = getAccount()
      pass = true
      err = ""
      old = params[:password][:old]
      new1 = params[:password][:new1]
      new2 = params[:password][:new2]
      if new1.length < 6 or new1.length > 18
        pass = false
        err = "Length of password should be between 6 and 18."
      end
       
      if new1 != new2
        pass = false
        err = "The retyped password doesn't match the new password."
      end
      
      if old != @account.password
        pass = false
        err = "The password you entered doesn't match the password in our system."
      end
      
      if pass
        @account.update_attribute("password", new1)
        flash[:notice] = "Password updated."
        redirect_to :action=>'account', :controller=>'go'
      else
        flash[:notice] = err
        redirect_to :action=>'account', :controller=>'go'
      end    
      
    else
      flash[:notice] = "Please login."
      redirect_to :action=>'login', :controller=>'go'
    end
    
    if request.get?
      redirect_to(:action => "index", :controller =>"go")
    end    
  end
  
  def place_order
    session[:label] = ""
    @page_title = "Place your Order"
    
    @account = getAccount()
    @cart = session[:cart]
    session[:freight_suggests] = "" if session[:freight_suggests].blank?
    
    if request.get?
      @passed = false
      @passed = true if params[:securitylevel] == "1"
      if @account.blank? or @passed == false
        redirect_to :action=>'login',:controller=>'go' 
      else
        render(:file => "#{RAILS_ROOT}/app/views/templates/#{Shop.def_template_name}/frontend/#{action_name}.html.erb", 
          :layout => true)
      end  
    end
    
    if request.post?
      # check order
      
      content_pass = true
      content_pass = false if @account.blank?
      content_pass = false if @account.id != session[:account_id]
      content_pass = false if @cart.blank?
      content_pass = false if @cart.items.size <= 0
      content_pass = false if session[:freight_cost].blank?
      content_pass = false if params[:order][:shipping_address].blank?
      #content_pass = false if params[:order][:postcode].blank?
      
      if content_pass
        # save order
        
        all_saved_without_error = true
        
        order = Order.new
        order.time_created = Time.now
        order.customer_id = @account.id
       
        order.shipping_address = params[:order][:shipping_address]
        order.postcode = params[:order][:postcode]
        order.donee = params[:order][:donee]
        order.suggested_freight_cost = session[:freight_cost].to_f
        order.suggested_freight_options = session[:freight_suggests]
        order.last_time_of_sentmail = nil
        order.note = params[:order][:note]
        order.note = "No additional notes." if params[:order][:note].blank?
        order.status = "New"
        
        if order.save
          
          saved_items = []
          
          # create order items
          for item in @cart.items
            product = Product.find(item.product_id)
            orderitem = Orderitem.new
            orderitem.order_id = order.id
            orderitem.product_id = item.product_id
            
            price_in_order = product.price_for_account(@account)
            #price_in_order = price_in_order * (1 - @discount_percentage.to_f/100)
            
            orderitem.price_in_order = price_in_order
            orderitem.quantity = item.quantity
            
            if orderitem.save
              # saved
              saved_items << orderitem.id
            else  
              all_saved_without_error = false
            end
          end
          
          if all_saved_without_error
            # all saved

          else
            # remove saved orderitems and the saved order
            for item_id in saved_items
              saved_item = Orderitem.find(item_id)
              saved_item.destory
            end  
          end
          
        else
          all_saved_without_error = false
        end   
        
        if all_saved_without_error
          # send email to admin
          OrderMailer.deliver_ordernotice(order)
          # send email to customer
          #email = OrderMailer.create_confirm(order)
          #email.set_content_type("text/html")
          OrderMailer.deliver_confirm(order)
          
          flash[:notice] = "Order has been placed!"
          redirect_to :action=>'order_has_been_placed'
        else
          flash[:notice] = "Sorry, your order couldn't be placed. Please make sure you entered all information."
          redirect_to :back
        end    
        
        # send email to admin
        
        # send email to customer
        
      else
        flash[:notice] = "Sorry, your order couldn't be placed. Please make sure you entered all information."
        redirect_to :back
      end    
    end
    
  end
  
  
  
  def ajax_add_to_cart
    #
    
  end
  
  def add_to_cart
    if request.post?
      product = Product.find(params[:pid])
      
      ui = params[:ui]
      
      account = getAccount()
	    
      quantity = 0
	    
      quantity = params[:cart][:quantity].to_i if params[:cart] and params[:cart][:quantity]
      
      session[:cart] = SessionCart.new(account) if session[:cart].nil?
      session[:cart].add_product(product.id)
	
      if quantity >= 2 and quantity <= 50
        for i in 1..quantity-1
          session[:cart].add_product(product.id)
        end  
      end  
	      
      flash[:notice] = "Product(s) has been added to shopping cart."
      
      if ui == "1"
        redirect_to(:action=>'product',:controller=>'go', :id=>product.id)
      else
        redirect_to(:action=>'view_cart',:controller=>'go', :id=>product.id)
      end
      
      
      #      else
      #        #
      #        flash[:notice] = "We are sorry, please login first."
      #	      
      #        session[:should_remember_product_id] = true
      #	      
      #        redirect_to(:action => "login", :controller =>"go")
      #      end    
    end
	  
    if request.get?
      redirect_to(:action => "index", :controller =>"go")
    end
  end
	
  def delete_from_cart
    if request.post?
      
      product = Product.find(params[:pid])
      #account = getAccount()
	    
      session[:cart].delete_product(product.id)
      flash[:notice] = "Product has been removed from cart."      
      
      redirect_to(:action => "view_cart", :controller =>"go", :id=>product.id)
      
    end
	  
    if request.get?
      redirect_to(:action => "index", :controller =>"go")
    end  
  end
	
  def decrease_quantity
    if request.post?
      product = Product.find(params[:pid])
      #account = getAccount()
	    
      session[:cart].decrease_quantity product
      flash[:notice] = "One product has been removed from cart."
      redirect_to :action=>'view_cart', :controller=>'go', :id=>product.id
      
    end
	  
    if request.get?
      redirect_to(:action => "index", :controller =>"go")
    end
  end
	
  def password_resend
    if request.get?
      #
      render(:file => "#{RAILS_ROOT}/app/views/templates/#{Shop.def_template_name}/frontend/#{action_name}.html.erb", 
        :layout => true)
    end
	  
    if request.post?
      email = params[:password][:email]
      account = Account.find_by_email(email)
	    
      if account
        # send email
        OrderMailer.deliver_accountnew(account)
        flash[:notice] = "Your account information has been sent: " + account.email
        redirect_to :action=>'password_resend', :controller=>'go'
      else
        flash[:notice] = "Invalid Email address"
        redirect_to :action=>'password_resend', :controller=>'go'
      end    
    end  
  end
  ###########################
  ## No Render actions END ##
  ###########################
  
  
  
	
  ###################################
  ## BEGIN Frontstore AJAX Methods ##
  ###################################
	
  def large_image
    if request.get? or request.post?
      @picture = Productimage.find(params[:pid])
      render :partial=>"templates/#{Shop.def_template_name}/frontend/large"
  	  
    end  
  end
	
  def freight
    session[:label] = ""
    @account = getAccount()
    @cart = session[:cart]
    
    if params[:island] == "1"
      @island = "North"
    else
      @island = "South"
    end
    
    if params[:rural] == "true"
      @rural = "Yes"
    else
      @rural = "No"
    end   
    render :partial=>"templates/#{Shop.def_template_name}/frontend/freight"
  end
  ####################################
  ## END of Frontstore AJAX Methods ##
  ####################################
	
  private

  def getAccount()
    if session[:account_id] != nil
      # return as an account holder
      account = Account.find(session[:account_id])
      return account
    else
      # TODO: Create tmp account for visitiors
      # return as a guest
      return nil
    end    
  end  
end
