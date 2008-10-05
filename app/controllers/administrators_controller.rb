######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################

## TODO: Administrator account manager

class AdministratorsController < ApplicationController
  before_filter :authorize
  layout 'admin'

  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  
  def list
    #@administrator_pages, @administrators = paginate :administrators, :per_page => 10
  end

  def show
    @administrator = Administrator.find(params[:id])
  end

  def new
    @administrator = Administrator.new
  end

  def create
    @administrator = Administrator.new(params[:administrator])
    if @administrator.save
      flash[:notice] = 'Administrator was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    #@administrator = Administrator.find(params[:id])
    @administrator = Administrator.find(1)
  end

  def update
    #@administrator = Administrator.find(params[:id])
    @administrator = Administrator.find(1)
    if @administrator.update_attributes(params[:administrator])
      flash[:notice] = 'Administrator password was successfully updated.'
      redirect_to :action => 'edit', :controller=>'administrators'
    else
      redirect_to :action => 'edit', :controller=>'administrators'
    end
  end

  def destroy
    Administrator.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
private
    def authorize
      if not session[:admin_id] 
      	flash[:notice] = "Please log in"
      	redirect_to(:action => "login", :controller => "admin")
      end
    end
end
