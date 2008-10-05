######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################


class AdminController < ApplicationController
  before_filter :authorize, :except=>["login","logout"]
  
  ## Methods for admin functions
  
  def index
    # index
    @page_title = "EcomPages Admin"
  end
  
  
  def install_dir_update
    shop = Shop.find(1)
    shop.update_attribute('install_dir_name', params[:app][:install_dir_name])
    
    flash[:notice] = "Application directory updated."
    redirect_to(:action=>'store_info')
  end
  
  def store_info
    #
    if request.get?
      #
      @store = Shop.find(1)
    end
    if request.post?
      shop = Shop.find(1)
      shop.update_attribute('shop_name', params[:store][:shop_name])
      shop.update_attribute('admin_email', params[:store][:admin_email])
      shop.update_attribute('company_name', params[:store][:company_name])
      shop.update_attribute('b_addr', params[:store][:b_addr])
      shop.update_attribute('b_phone', params[:store][:b_phone])
      shop.update_attribute('b_mobile', params[:store][:b_mobile])
      shop.update_attribute('b_bank_acct', params[:store][:b_bank_acct])
      shop.update_attribute('b_website', params[:store][:b_website])
      
      flash[:notice] = "Store Info Updated."
      redirect_to(:action=>'store_info')
    end
  end
  
  def change_template
    if request.post?
      tmpl = params[:tmpl]
      shop = Shop.def_store
      shop.update_attribute('def_template_name', tmpl)
      flash[:notice] = "Template Changed."
      redirect_to(:action=>'change_template', :controller=>'admin')
    end
    
    if request.get?
      #
    end    
  end  
  
  def set_donation
    if Shop.allow_donation == 1
      Shop.def_store.update_attribute("allow_donation", 0)
      flash[:notice] = "Donation function has been turned off."
      redirect_to :action=>'list', :controller=>'charities'
    else
      Shop.def_store.update_attribute("allow_donation", 1)
      flash[:notice] = "Donation function has been turned on."
      redirect_to :action=>'list', :controller=>'charities'
    end    
  end  
  
  
  def edit_email_templates
    
  end  
  
  def edit_email_template
    if request.get?
      @code = params[:id].to_i
      
      file_name = "accountnew.html.erb" if @code == 1
      file_name = "confirm.html.erb" if @code == 2
      file_name = "statusnotice.html.erb" if @code == 3
      
      html_code = ""
      html_file = File.new("#{RAILS_ROOT}/app/views/order_mailer/#{file_name}", "r")
      html_file.each {
      	|i|
      	html_code += i
      }

      html_file.close()

      @html = html_code
    end
    
    if request.post?
      html = params[:html][:code]
      code = params[:fid].to_i
      
      file_name = "accountnew.html.erb" if code == 1
      file_name = "confirm.html.erb" if code == 2
      file_name = "statusnotice.html.erb" if code == 3
      outfile = File.new("#{RAILS_ROOT}/app/views/order_mailer/#{file_name}", "w")
      outfile.write html
      outfile.close()
      flash[:notice] = "Template Updated."
      redirect_to :action=>'edit_email_templates', :controller=>'admin'
    end  
  end
  
  
  def update_order_status
    if request.post?
      order = Order.find(params[:oid])
      flash[:notice] = "Order information saved."
      if params[:status][:inform] == "1"
        OrderMailer.deliver_statusnotice(order)
        flash[:notice] = "Order update information has been sent to customer."
      end  
      
      redirect_to :action=>'order', :controller=>'admin', :id=>order.id
    end  
  end  
  
  def sendemails
    if request.get?
      #
    end
    
    if request.post?
      subject = params[:emails][:subject]
      body = params[:emails][:body]
      group = params[:emails][:group]
      
      accounts = Account.find(:all)
      for account in accounts
        # send email
        if group == "all"
          email = OrderMailer.create_sendall(account, subject, body)
          email.set_content_type("text/html")
          OrderMailer.deliver(email)
        end
        
        if group == "special"
          email = OrderMailer.create_sendall(account, subject, body)
          email.set_content_type("text/html")
          OrderMailer.deliver(email) if account.special_offers == 1
          
        end 
      end
      
      flash[:notice] = "Message has been sent to customers."
      redirect_to :action=>'sendemails', :controller=>'admin'
    end  
  end  
  
  def index_category_label
    if request.get?
      #
    end
    
    if request.post?
      for cate in Category.find(:all)
        cate.update_attribute("label","")
      end  

      for product in Product.find(:all)
        category = product.category

        product_label = product.labels + ""
        product_label = product_label.downcase
        product_label = product_label.gsub(/[\[\]]/, ' ')

        label_array = product_label.split(' ')
        #product_label.scan(/\w+/) {|w| print "<<#{w}>> " }

        for l in label_array
          if not category.label.include?(l)
            category.update_attribute("label",category.label + l + " ")
          end
        end     
      end
      
      flash[:notice] = "Category Indexing was successfully completed."
      redirect_to :action=>"index_category_label", :controller=>'admin'
    end 
  end  
  
  def header_message
    if request.post?
      shop = Shop.def_store
      shop.update_attribute('header_message',params[:shop][:header_message])
      flash[:notice] = "Header Message Updated"
      redirect_to :action=>'header_message', :controller=>'admin'
    end
    
    if request.get?
      @shop = Shop.def_store
    end
  end
  
  def category_sort
    if request.post?
      
    end
    
    if request.get?
      @categories = Category.top_level_categories
    end
  end
  
  def ajax_category_sort
    @category_id_array = params[:list]
    
    i = 1
    for c_id in @category_id_array
      category = Category.find(c_id)
      category.update_attribute('level_order', i)
      i+=1
    end  
    
    render :partial => 'category_list'
  end  
  
  def logout
    session[:admin] = nil
    flash[:notice] = "Logged out."
    redirect_to :action=>'login', :controller=>'admin'
  end  
  
  def login
    # auth
    if request.post?
      admin = Administrator.new(params[:admin])
      logged_in_admin = admin.try_to_login
      if logged_in_admin
        # passed
        session[:admin_id] = logged_in_admin.id
        redirect_to(:action => "index", :controller =>"admin")
      else
        flash[:notice] = "Invalid user/password combination."
        redirect_to(:action => "login", :controller =>"admin")
      end
    end
    
    # show login page
    if request.get?
      session[:admin_id] = nil
      render :layout=>'adminlogin'
    end
  end  
  
  
  ## Methods for Order Manager
  def orders
    if request.get?
      @page_title = "Order Manager"
      @orders = Order.find(:all, :order=>'id DESC')
    end  
  end
  
  def order
    
    @order = Order.find(params[:id])
    @page_title = "Order No. " + @order.id.to_s
    @feedback = ""
  end
  
  def destroy_order
    Order.find(params[:id]).destroy
    flash[:notice] = "Order #{params[:id]} was removed."
    redirect_to :action => 'orders'
  end
  
  def tax
    if request.get?
      #
      
    end
    
    if request.post?
      #
      tax_name = params[:tax][:tax_short_name]
      tax_rate = params[:tax][:tax_rate]
      tax_incl = params[:tax][:tax_incl]
      
      Shop.def_store.update_attribute('tax_name', tax_name)
      Shop.def_store.update_attribute('tax_rate', tax_rate)
      Shop.def_store.update_attribute('is_tax_incl_when_adding_new_product', tax_incl)
      
      flash[:notice] = "Tax configuration updated."
      redirect_to :action => 'tax'
    end
    
  end
  
  
  ## End of methods for order manager
  
  
  
  # AJAX methods
  
  def update_ajax_order_quantity_shipped
    orderitem = Orderitem.find(params[:id])
    if params[:field] == "quantity_shipped"
      newquantityshipped = params[:nvalue]
      newquantityshipped = orderitem.quantity_shipped if newquantityshipped.blank?
		  
      orderitem.update_attributes("quantity_shipped"=>newquantityshipped.to_i)
      render :layout => false, :inline => orderitem.quantity_shipped.to_s
    end
  end
  
  def update_ajax_order_date_shipped
    order = Order.find(params[:id])
    if params[:field] == "date_shipped"
      newdateshipped = params[:nvalue]
      newdateshipped = order.date_shipped if newdateshipped.blank?
		  
      order.update_attributes("date_shipped"=>newdateshipped)
      render :layout => false, :inline => order.date_shipped
    end
  end
  
  def update_ajax_order_arrival_date
    order = Order.find(params[:id])
    if params[:field] == "arrival_date"
      newdateshipped = params[:nvalue]
      newdateshipped = order.arrival_date if newdateshipped.blank?
		  
      order.update_attributes("arrival_date"=>newdateshipped)
      render :layout => false, :inline => order.arrival_date
    end
  end  
  
  def update_ajax_order_serial
    order = Order.find(params[:id])
    if params[:field] == "track_numbers"
      newtracknumbers = params[:nvalue]
      newtracknumbers = order.track_numbers if newtracknumbers.blank?
		  
      order.update_attributes("track_numbers"=>newtracknumbers)
      render :layout => false, :inline => order.track_numbers
    end
  end
  
  def update_ajax_order_suggested_freight_options
    order = Order.find(params[:id])
    if params[:field] == "suggested_freight_options"
      newsuggested_freight_options = params[:nvalue]
      newsuggested_freight_options = order.suggested_freight_options if newsuggested_freight_options.blank?
		  
      order.update_attributes("suggested_freight_options"=>newsuggested_freight_options)
      render :layout => false, :inline => order.suggested_freight_options
    end
  end  
  
  def update_ajax_order_suggested_freight_cost
    order = Order.find(params[:id])
    if params[:field] == "suggested_freight_cost"
      newsuggested_freight_cost = params[:nvalue]
      newsuggested_freight_cost = order.suggested_freight_cost if newsuggested_freight_cost.blank?
		  
      order.update_attributes("suggested_freight_cost"=>newsuggested_freight_cost)
      render :layout => false, :inline => order.suggested_freight_cost.to_s
    end
  end
    
  
  def update_ajax_optionbox
    order = Order.find(params[:order_id])
    order.status = params[:value]
    if order.save
      @feedback = "<font color=green>Status was successfully updated.</font>"
      render :partial =>'feedback'
    else
      @feedback = "<font color=red>Status was not successfully updated.</font>"
      render :partial =>'feedback'
    end    
  end
  
  def update_ajax_order_note
    order = Order.find(params[:id])
    if params[:field] == "note"
      newnote = params[:nvalue]
      newnote = "No additional note" if newnote.blank?
		  
      order.update_attributes("note"=>newnote)
      render :layout => false, :inline => order.note
    end
  end
  
  def update_ajax_price_matrix
    pricelevelmatrix = Pricelevelsmatrix.find(:first, 
      :conditions=>["pricelevel_id = ? and product_id = ?", 
        params[:pricelevel_id], 
        params[:product_id]])
                                 
    newprice = params[:nvalue]
    if newprice.blank?
      newprice = 0.0
    else
      if newprice.index('%') != nil
        percent = newprice.delete '%'
        percent = percent.to_f
        
        product = Product.find(params[:product_id])
        
        newprice = product.price * (1 - percent / 100)
      end    
    end    
    
    pricelevelmatrix.update_attributes("price"=>newprice)
    render :layout => false, :inline => pricelevelmatrix.price.to_s
  rescue
    render :layout => false, :inline => 0.0  
  end  
  
  def update_ajax_category_name
    category = Category.find(params[:id])
    if params[:field] == "name"
      newname = params[:nvalue]
      newname = "No Name." if newname.blank?
		  
      category.update_attributes("name"=>newname)
      render :layout => false, :inline => category.name
    end
  end
  ## End of AJAX methods
  
  
  
  ## Methods for Account Manager
  def accounts
    if request.get?
      @page_title = "Account Manager"
      @accounts = Account.find(:all, :order=>'id DESC')
    end  
  end
  
  def account
    @page_title = "Account"
    @account = Account.find(params[:id])
  end
  
  def update_account
    @page_title = "Update Account"
    @account = Account.find(params[:id])
    if @account.update_attributes(params[:account])
      flash[:notice] = 'Account was successfully updated.'
      redirect_to :action => 'account', :id => @account
    else
      render :action => 'account'
    end
  end
  
  def destroy_account
    has_order = Order.find_by_customer_id(params[:id])
    
    if has_order
      flash[:notice] = "Sorry that system can't delete an account that has order(s). <br/> Solution: 'delete the orders belong to this customer before removing his/her account.'"
      redirect_to :action => 'accounts', :controller=>'admin'
    else
      Account.find(params[:id]).destroy
      redirect_to :action => 'accounts', :controller=>'admin'
    end    
    
  end
  ## End of methods for Account Manager
  
  
  ## Category Manager
  def categories
    #
    @page_title = "Categories"
  end  
  ## End of methods for Category Manager
  
  
  ## TODO: delete all orders
  # testing
  #def xxx_clear_orders
  #orders = Order.find(:all)
  #for o in orders
  #o.destroy
  #end  
  #end
	
  ## TODO: graphical statistics
  def stats_img1
    require 'rubygems'
    require 'gruff'

    g = Gruff::Line.new(400)
    g.title = "Statistics - (last 7 days)" 

    days = get_days(7)
    num_orders_days = []
    num_accts_days = []
    for i in 1..7
      day = days[i-1]
      num_orders_days << get_num_orders(day)
      num_accts_days << get_num_accts(day)
    end
    
    
    g.data("Number of Orders", num_orders_days)
    g.data("Number of Accounts", num_accts_days)
    
    g.labels = {0 => days[0].to_s(:short), 
            1 => days[1].to_s(:short), 
            2 => days[2].to_s(:short), 
            3 => days[3].to_s(:short), 
            4 => days[4].to_s(:short), 
            5 => days[5].to_s(:short), 
            6 => days[6].to_s(:short)}

    #g.write('my_fruity_graph.png')
    #g.theme_keynote()
    g.theme_37signals
    send_data(g.to_blob,
      :disposition => 'inline' ,
      :type => 'image/png' ,
      :filename => "code_stats.png" )
  end
  


  ## private methods
  private
  def authorize
    if not session[:admin_id] 
      flash[:notice] = "Please log in"
      redirect_to(:action => "login", :controller => "admin")
    end
  end
  
  def get_days(num_day)
    days = []
    today = Date.today
    
    for i in 1..num_day
      day = today - (num_day - i)
      days << day
    end  
    return days
  end
  
  def get_num_orders(date)
    orders = Order.find(:all, :conditions=>["time_created <= ?", date])
    return orders.size
  end
  def get_num_accts(date)
    accts = Account.find(:all, :conditions=>["time_created <= ?", date])
    return accts.size
  end
  
end
