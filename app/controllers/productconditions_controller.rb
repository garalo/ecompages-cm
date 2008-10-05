######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################


## TODO: Code clear
class ProductconditionsController < ApplicationController
  before_filter :authorize
  layout 'admin'

  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @page_title = "Condition Labels"
    @productconditions = Productcondition.find(:all)
  end

  def show
    @page_title = "Condition Labels"
    @productcondition = Productcondition.find(params[:id])
  end

  def new
    @page_title = "Condition Labels"
    @productcondition = Productcondition.new
  end

  def create
    @productcondition = Productcondition.new(params[:productcondition])
    if @productcondition.save
      flash[:notice] = 'Product Condition was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @page_title = "Condition Labels"
    @productcondition = Productcondition.find(params[:id])
  end

  def update
    @productcondition = Productcondition.find(params[:id])
    if @productcondition.update_attributes(params[:productcondition])
      flash[:notice] = 'Product Condition was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Productcondition.find(params[:id]).destroy
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
