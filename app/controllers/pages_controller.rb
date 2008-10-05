######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################

## TODO: Code clear
class PagesController < ApplicationController
  before_filter :authorize, :except=>['view']
  layout 'admin'

  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @def_pages = Page.find(:all, :conditions=>["id <= 4"], :order=>"id DESC")
    @cus_pages = Page.find(:all, :conditions=>["id > 4"], :order=>"id DESC")
  end

  def show
    @page = Page.find(params[:id])
  end

  def new
    @page = Page.new
    @image = Imageobject.new
    @images = Imageobject.find(:all, :order=>'id DESC')
  end

  def create
    @page = Page.new(params[:page])
    @page.created_at = Time.now
    @page.value = "page content ..."
    if @page.save
      flash[:notice] = 'Page was successfully created.'
      redirect_to :action => 'list', :controller=>'pages'
    else
      flash[:notice] = 'Sorry, Page was not successfully created.'
      redirect_to :action => 'list', :controller=>'pages'
    end
  end

  def edit
    @page = Page.find(params[:id])
    @image = Imageobject.new
    @images = Imageobject.find(:all, :order=>'id DESC')
  end

  def update
    @page = Page.find(params[:id])
    @page.created_at = Time.now
    if @page.update_attributes(params[:page])
      flash[:notice] = 'Page was successfully updated.'
      redirect_to :action => 'show', :id => @page
    else
      render :action => 'edit'
    end
  end

  def destroy
    Page.find(params[:id]).destroy if params[:id].to_i > 4
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
