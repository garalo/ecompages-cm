######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################

## TODO: Code clear
class ProductwarrantiesController < ApplicationController
  before_filter :authorize
  layout 'admin'
  
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @page_title = "Warranty Labels"
    @productwarranties = Productwarranty.find(:all)
  end

  def show
    @page_title = "Warranty Labels"
    @productwarranty = Productwarranty.find(params[:id])
  end

  def new
    @page_title = "Warranty Labels"
    @productwarranty = Productwarranty.new
  end

  def create
    @productwarranty = Productwarranty.new(params[:productwarranty])
    if @productwarranty.save
      flash[:notice] = 'Product Warranty was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @page_title = "Warranty Labels"
    @productwarranty = Productwarranty.find(params[:id])
  end

  def update
    @productwarranty = Productwarranty.find(params[:id])
    if @productwarranty.update_attributes(params[:productwarranty])
      flash[:notice] = 'Product Warranty was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Productwarranty.find(params[:id]).destroy
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
