######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################

class CategoriesController < ApplicationController
  
  ## Create a category
  def create
    if request.post?
      @category = Category.new(params[:category])
      @category.level_num = Category.cal_level_num(@category)
      @category.name = "no-name" if @category.name.blank?
      if @category.save
        flash[:notice] = 'Category was successfully created.'
        redirect_to :action => 'categories', :controller=>'admin'
      else
        flash[:notice] = 'Category was not successfully created.'
        redirect_to :action => 'categories', :controller=>'admin'
      end
    end  
  end
  
  def delete
    if request.post?
        category = Category.find(params[:id])
        
        if category.id == 1
          
          flash[:notice] = "Sorry, the system can't delete the root category."
          redirect_to :action => 'categories', :controller=>'admin'
        else
          if category.number_of_sub_categories > 0
            flash[:notice] = "'" + category.name + "' has sub-categories, please remove them first."
            redirect_to :action => 'categories', :controller=>'admin'
          else
            products = category.products
            
            if products.length >= 50
              flash[:notice] = 'This category contains at least 50 products, please try again.'
              redirect_to :action => 'categories', :controller=>'admin'
            else
              for product in products 
                product.update_attribute("category_id",1)
              end
                
              category.destroy
              flash[:notice] = 'Category was successfully deleted.'
              redirect_to :action => 'categories', :controller=>'admin'
            end    
          end    
        end    
    end  
  end
  
  ## TODO: delete all categories
  def dell
    for c in Category.find(:all,:conditions=>["id != ?", 1])
      c.destroy
    end  
  end  
end
