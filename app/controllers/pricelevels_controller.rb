######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################

## TODO: Code clear
class PricelevelsController < ApplicationController
  before_filter :authorize
  layout 'admin'
  
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @page_title = "Price Levels"
    @pricelevels = Pricelevel.find(:all, :conditions=>["id != ?", 1])
  end

  def show
    @page_title = "Price Levels"
    @pricelevel = Pricelevel.find(params[:id])
  end

  def new
    @page_title = "Price Levels"
    @pricelevel = Pricelevel.new
  end

  def create
    @pricelevel = Pricelevel.new(params[:pricelevel])
    if @pricelevel.save
      flash[:notice] = 'Pricelevel was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @page_title = "Price Levels"
    @pricelevel = Pricelevel.find(params[:id])
  end

  def update
    @pricelevel = Pricelevel.find(params[:id])
    if @pricelevel.update_attributes(params[:pricelevel])
      flash[:notice] = 'Pricelevel was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Pricelevel.find(params[:id]).destroy unless params[:id].to_s == "1"
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
