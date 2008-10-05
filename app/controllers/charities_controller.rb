
######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################


## TODO: Clear code

class CharitiesController < ApplicationController
  
  before_filter :authorize
  layout 'admin'
  
  
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @charities = Charity.find(:all)
  end

  def new
    @charity = Charity.new
  end

  def create
    @charity = Charity.new(params[:charity])
    if @charity.save
      flash[:notice] = 'Charity was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @charity = Charity.find(params[:id])
  end

  def update
    @charity = Charity.find(params[:id])
    if @charity.update_attributes(params[:charity])
      flash[:notice] = 'Charity was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Charity.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

private
  def authorize
    if not session[:admin_id] 
        flash[:notice] = "Please log in."
        redirect_to(:action => "login", :controller => "admin")
    end
  end
end
