######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################

## TODO: Code clear
class TabsController < ApplicationController
  before_filter :authorize
  layout 'admin'
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @tabs = Tab.find(:all, :order => 'position')
  end

  def show
    @tab = Tab.find(params[:id])
  end

  def new
    @tab = Tab.new
  end

  def create
    @tab = Tab.new(params[:tab])
    @tab.position = 0
    @tab.position = Tab.count if Tab.count > 0
    
    if @tab.save
      flash[:notice] = 'Tab was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @tab = Tab.find(params[:id])
  end
  
  def move
    tab = Tab.find(params[:tid])
    if (params[:to]) == "up"
      # move up
      tabs = Tab.find(:all, :order => 'position')
      index = 0
      i = 0
      for t in tabs
        if (tab.id == t.id)
          index = i
        end  
        i += 1
      end  
      
      if index > 0
        last_tab = tabs[index - 1]
        last_tab.update_attribute('position', last_tab.position + 1) # move node down
        tab.update_attribute('position', tab.position - 1) # move current node up
      end  
      
    else
      
      # move down
      tabs = Tab.find(:all, :order => 'position')
      index = tabs.size - 1
      i = 0
      for t in tabs
        if (tab.id == t.id)
          index = i
        end  
        i += 1
      end  
      
      if index < tabs.size - 1
        next_tab = tabs[index + 1]
        next_tab.update_attribute('position', next_tab.position - 1) # move last node up
        tab.update_attribute('position', tab.position + 1) # move current node down
      end
      
    end
    #flash[:notice] = 'Tab was successfully moved ' + params[:to] + '.'
    redirect_to :action => 'list', :controller=>'tabs'
  end

  def update
    @tab = Tab.find(params[:id])
    old_name = @tab.name
    if @tab.update_attributes(params[:tab])
      
      # update products
      for product in Product.find(:all)
        labels = product.labels
        labels = labels.gsub("#{old_name}", "#{@tab.name}")
        product.update_attribute('labels', labels)
      end  
      
      flash[:notice] = 'Tab was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    tab = Tab.find(params[:id])
    tabs = Tab.find(:all, :order => 'position')
    for t in tabs
      if t.position > tab.position
        t.update_attribute('position', t.position - 1)
      end  
    end  
    tab.destroy
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
