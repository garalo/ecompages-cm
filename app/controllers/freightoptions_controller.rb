######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################

## TODO: Clear code

class FreightoptionsController < ApplicationController
  before_filter :authorize
  layout 'admin'
 
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @freightoptions = Freightoption.find(:all)
  end

  def show
    @freightoption = Freightoption.find(params[:id])
  end

  def new
    @freightoption = Freightoption.new
  end

  def create
    @freightoption = Freightoption.new(params[:freightoption])
    if @freightoption.save
      flash[:notice] = 'Freightoption was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @freightoption = Freightoption.find(params[:id])
  end

  def update
    @freightoption = Freightoption.find(params[:id])
    if @freightoption.update_attributes(params[:freightoption])
      flash[:notice] = 'Freightoption was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Freightoption.find(params[:id]).destroy
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
