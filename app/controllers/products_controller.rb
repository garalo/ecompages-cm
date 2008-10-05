######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################

## TODO: Code clear
class ProductsController < ApplicationController
  before_filter :authorize
  layout 'admin'
  
  verify :method => :post, :only => [ :destroy, :create, :update ],
    :redirect_to => { :action => :list }

  def price_matrix
    @page_title = "Product Manager"
    
    session[:product_sort_field] = "id" if session[:product_sort_field].nil?
    session[:product_sort_by] = "desc" if session[:product_sort_by].nil?
    
    session[:product_sort_field] = params[:sort_field] if params[:sort_field] != nil
    
    if params[:sort_by] != nil
      if params[:sort_by] == "desc"
        session[:product_sort_by] = "desc" 
      else  
        session[:product_sort_by] = "asc"
      end  
    end    
    
    sort_string = session[:product_sort_field] + " " + session[:product_sort_by]
    
    
    @pricelevels = Pricelevel.find(:all, :conditions=>["id != 1"])
    
    @products = Product.paginate(:order=> sort_string, 
      :per_page => 20, 
      :page=>params[:page])
                                  
  end  
  
  def list
    @page_title = "Product Manager"
    
    session[:product_sort_field] = "id" if session[:product_sort_field].nil?
    session[:product_sort_by] = "desc" if session[:product_sort_by].nil?
    
    session[:product_sort_field] = params[:sort_field] if params[:sort_field] != nil
    
    if params[:sort_by] != nil
      if params[:sort_by] == "desc"
        session[:product_sort_by] = "desc" 
      else  
        session[:product_sort_by] = "asc"
      end  
    end    
    
    sort_string = session[:product_sort_field] + " " + session[:product_sort_by]
    
    @products = Product.paginate(:order=> sort_string, 
      :per_page => 20, 
      :page=>params[:page])
    
    
    #flash[:notice] = sort_string
  end

  def show
    @page_title = "Product Manager"
    @product = Product.find(params[:id])
  end

  def new
    @page_title = "Product Manager"
    @product = Product.new
    
  end

  def create
    @page_title = "Product Manager"
    @product = Product.new(params[:product])
    @product.condition_id = 0 if @product.condition_id == nil
    @product.warranty_id = 0 if @product.warranty_id == nil
    @product.time_created = Time.now
    
    if @product.save
      flash[:notice] = 'Product was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    
    @page_title = "Product Manager"
    @product = Product.find(params[:id])
  end

  def update
    @page_title = "Product Manager"
    @product = Product.find(params[:id])
    @product.condition_id = 0 if @product.condition_id == nil
    @product.warranty_id = 0 if @product.warranty_id == nil
    @product.time_created = Time.now if @product.time_created == nil
    
    
    if @product.update_attributes(params[:product])
      flash[:notice] = 'Product was successfully updated.'
      redirect_to :action => 'edit', :id => @product
    else
      render :action => 'edit'
    end
  end

  def destroy
    
    size = Orderitem.find(:all, :conditions=>["product_id = ?", params[:id]]).size
    if size > 0
      flash[:notice] = "This product couldn't be deleted. <br/><b>Make sure this product is not incldued in any order.</b>"
    else
      #
      Product.find(params[:id]).destroy
    end    
    
    redirect_to :action => 'list'
  end
  
  
  def add_image
    @page_title = "Product Manager"
    
    if request.post?
      if params[:productimage].blank?
	      
        flash[:notice] = 'Product image was not successfully uploaded.'
      	redirect_to :action=>'show',:controller=>'products',:id=>product
      else
  		  
        image = Productimage.new(params[:productimage])
        product = Product.find(params[:pid])
  			
        image.product_id = product.id

        if image.save
  			  
          if image.image.blank?
            for i in product.images
              i.destroy if i.id == image.id
            end
            flash[:notice] = 'Product image was not successfully uploaded.'
          else
            flash[:notice] = 'Product image was successfully uploaded.'
          end
        else
          flash[:notice] = 'Product image was not uploaded.'
        end
      end
      redirect_to :action=>'show',:controller=>'products',:id=>product
    end
	  
    if request.get?
      redirect_to :action=>'show',:controller=>'products',:id=>params[:pid]
    end  
  end
  
  def delete_image
    if request.post?
      image = Productimage.find(params[:id])
      image.destroy
      flash[:notice] = 'Product image was successfully removed.'
      redirect_to :back
    end  
  end  
  private
  def authorize
    if not session[:admin_id] 
      flash[:notice] = "Please log in"
      redirect_to(:action => "login", :controller => "admin")
    end
  end
end
