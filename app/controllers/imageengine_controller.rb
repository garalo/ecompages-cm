######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################

## TODO: Code clear
## TODO: site url for page editor
class ImageengineController < ApplicationController
  
  def index
    @page_title = "Image Engine"
    @image = Imageobject.new
    
    @images = Imageobject.find(:all, :order=>'id DESC')
  end
  
  def add_image
    @page_title = "Adding image ..."
    pid = params[:page_id]
    if request.post?
      if params[:imageobject].blank?
	      
        flash[:notice] = 'Image was not successfully uploaded.'
      	redirect_to :action=>'edit',:controller=>'pages', :id=>pid
      else
  		  
        image = Imageobject.new(params[:imageobject])
  			
        if image.save
  			  
          if image.image.blank?
  			    
            image.destroy
            flash[:notice] = 'Image was not successfully uploaded.'
          else
            flash[:notice] = 'Image was successfully uploaded.'
          end
        else
          flash[:notice] = 'Image was not successfully uploaded.'
        end
      end
      redirect_to :action=>'edit',:controller=>'pages', :id=>pid
    end
	  
    if request.get?
      redirect_to :action=>'edit',:controller=>'pages', :id=>pid
    end  
  end
  
  def delete_image
    if request.post?
      image = Imageobject.find(params[:id])
      image.destroy
      flash[:notice] = 'Image was successfully removed.'
      redirect_to :action=>'edit',:controller=>'pages', :id=>params[:pid]
    end  
  end    
end
