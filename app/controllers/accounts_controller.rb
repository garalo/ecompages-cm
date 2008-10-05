######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################


class AccountsController < ApplicationController
  
  # Set to default layout file if layout is nil
  layout "#{Shop.def_template_name}"
  
  verify :method => :post, :only => [ :create ],
    :redirect_to => { :action => :registration, :controller=>'go' }


  def new
    
    if session[:account_type] == 0 or session[:account_type] == 1
      @account = Account.new
      @account.account_type = session[:account_type]
      
      render(:file => "#{RAILS_ROOT}/app/views/templates/#{Shop.def_template_name}/accounts/#{action_name}.html.erb", 
        :layout => true)
    else
      redirect_to :action=>'registration',:controller=>'go'
    end    
  end

  def create
    
    @account = Account.new(params[:account])
    
    if not @account.agree_terms == 1
      flash[:notice] = "You need to read our terms and conditions before creating an account."
      redirect_to :back
    else  
    
      #setup def values
      @account.account_type = session[:account_type]
      #@account.password = "123456789"
      @account.price_level_id = 0
      @account.time_created = Time.now
      if @account.account_type = 1
        # 1 - Direct Buyer, so active now
        @account.suspended = 0
      else
        @account.suspended = 1
      end    
      @account.note = "This is a new account."
    
      if @account.save
        #send email to register
        OrderMailer.deliver_accountnew(@account)
        
        flash[:notice] = 'Account was successfully created.'
        redirect_to :action => 'thankyou'
      else
        render(:file => "#{RAILS_ROOT}/app/views/templates/#{Shop.def_template_name}/accounts/new.html.erb", 
          :layout => true)
      end
    end    
  end

  def thankyou
    render(:file => "#{RAILS_ROOT}/app/views/templates/#{Shop.def_template_name}/accounts/#{action_name}.html.erb", 
      :layout => true)
  end
  
    
  private
  
end