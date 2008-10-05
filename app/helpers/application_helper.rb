# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  ## TODO: Code clear
  def blank_space(num)
    html = ""
    for i in 1..num
      html += " &nbsp;"
    end
    return html
  end
  
  def show_tax_setting_for_frontend
    if Shop.is_tax_incl
      if Shop.tax_code_name.blank?
        ""
      else
        "(#{Shop.tax_code_name} incl.)"
      end
    else
      if Shop.tax_code_name.blank?
        ""
      else
        "(#{Shop.tax_code_name} excl.)"
      end
    end
  end
  
  def show_price_editor(pricelevel, product)
    price_set = true
    price_set = false if Pricelevelsmatrix.find(:all, :conditions=>["pricelevel_id = ? and product_id = ?", pricelevel.id, product.id]).size == 0
    
    if price_set
      pricematrix = Pricelevelsmatrix.find(:first, :conditions=>["pricelevel_id = ? and product_id = ?", pricelevel.id, product.id])
      
      "<span id=edit-pricelevel-#{pricelevel.id}-#{product.id}>#{pricematrix.price}</span><br/>
      <script>
      	new Ajax.InPlaceEditor('edit-pricelevel-#{pricelevel.id}-#{product.id}', 
      			'#{Shop.install_dir_name}/admin/update_ajax_price_matrix', 
      			{ callback: function(form, value) { 
      				return 'pricelevel_id=#{pricelevel.id}&product_id=#{product.id}&field=price&nvalue=' + escape(value) },
      				size:8});
      </script>"
      
    else
      newpricematrix = Pricelevelsmatrix.new
      newpricematrix.pricelevel_id = pricelevel.id
      newpricematrix.product_id = product.id
      newpricematrix.price = 0.0
      
      if newpricematrix.save
        "<span id=edit-pricelevel-#{pricelevel.id}-#{product.id}>#{newpricematrix.price}</span><br/>
        <script>
        	new Ajax.InPlaceEditor('edit-pricelevel-#{pricelevel.id}-#{product.id}', 
        			'#{Shop.install_dir_name}/admin/update_ajax_price_matrix', 
        			{ callback: function(form, value) { 
        				'pricelevel_id=#{pricelevel.id}&product_id=#{product.id}&field=price&nvalue=' + escape(value) },
        				size:8});
        </script>"
      else
        "Error"
      end    
    end
  end  
  
  def show_price_level(account)
    size = Pricelevel.find(:all, :conditions=>["id = ?", account.price_level_id]).size
    if size > 0
      return Pricelevel.find(account.price_level_id).title
    else
      return "Unknown"
    end    
    
  end
  
  def show_account_type(account)
    t = "Unknown"
    if account.account_type == 0
      t = "Dealer"
    end
    if account.account_type == 1
      t = "Direct Buyer"
    end
    return t
  end  
  
  def show_freight_option(product)
    
    if Freightoption.find(:all).size > 0
      fo = product.freightoption
      
      if fo
        if fo.price != 0.0
          return number_to_currency(fo.price)
        else
          return "n/a"
        end  
      else
        return "n/a"
      end
      
    else
      "Unknown"
    end
  end
    
  
  def show_first_image(product)
    if product.images.size > 0
      image_tag(url_for_file_column(product.images[0], "image", "large"))
    else
      image_tag("/images/no-image.gif")
    end  
  end  
  
  def show_price(product, account)
    
    #price = price * (1 - discount_percentage.to_f/100)
    
    if account.nil?
      # Show price including Tax
      
      if Shop.is_tax_incl
        price = product.price
      else
        price = product.price * (1 + Shop.tax_rate/100)
      end

    else
      #pricelevel = account.pricelevel
      
      if account.price_level_id <= 1
        #retail price account, excl GST
        #price = product.price
        
        if Shop.is_tax_incl
          price = product.price
        else
          price = product.price * (1 + Shop.tax_rate/100)
        end
      else
        pricelevelsmatrix = Pricelevelsmatrix.find(:first, 
          :conditions=>["pricelevel_id = ? and product_id = ?", 
            account.price_level_id, 
            product.id])
        if pricelevelsmatrix != nil
          #price = pricelevelsmatrix.price
          
          if Shop.is_tax_incl
            price = pricelevelsmatrix.price
          else
            price = pricelevelsmatrix.price * (1 + Shop.tax_rate/100)
          end
          
        else
          if Shop.is_tax_incl
            price = product.price
          else
            price = product.price * (1 + Shop.tax_rate/100)
          end
        end    
        
      end
    end    
    
    return number_to_currency(price)
  end  
  
  def show_cart(cart, account)
    empty_line = "<tr><td></td><td></td><td></td><td></td></tr>"
    
    if cart != nil and cart.size > 0
      html = "<fieldset><legend>"
      html += "<strong>"
      html += "#{cart.size} item(s) in your shopping cart "
      
      #if @passed
      #html += link_to "(Click here to Place an Order)", :action=>'place_order',:controller=>'go'
      #else
      html += link_to(" [Click here to Place Order] ", {:action=>'place_order',:controller=>'go', :securitylevel=>"1"})
      #end    
      
      html += "</strong> </legend>"
      html +="<table class=carttable>"
      html +="<tr><th></th><th>Product</th><th>Quantity</th><th>Price</th><th>Remove</th></tr>"
      #sub_total = 0
      for item in cart.items
        p = Product.find(item.product_id)
        html += "<tr>"
        del_str = link_to( image_tag("/images/trash.gif"), { :action => 'delete_from_cart', :pid => p }, :confirm => 'Are you sure to remove this product from your shopping cart?', :method => :post)
        img_str = show_product_image(p, "thumb")
        final_price = p.price_for_account(account)
        #final_price = final_price * (1 - account.discount_percentage.to_f/100)
        final_price = final_price * item.quantity
        inc_str = link_to(image_tag("/images/increase.gif"),{:action=>'add_to_cart', :pid=>p.id}, :method => :post)
        dec_str = ""
        dec_str = link_to(image_tag("/images/decrease.gif"),{:action=>'decrease_quantity', :pid=>p.id}, :method => :post) if item.quantity >= 2
        quan_str = inc_str + "&nbsp;&nbsp;&nbsp;" + item.quantity.to_s + "&nbsp;&nbsp;&nbsp;" + dec_str
        html += "<td>#{img_str}</td><td>#{p.title}</td><td>#{quan_str}</td><td>#{number_to_currency final_price}</td><td>#{del_str}</td>" 
        html += "</tr>"
        #sub_total += p.price
      end
      
      #html += empty_line
      html +="<tr><td></td><td>Sub total</td><td></td><td>#{number_to_currency cart.sub_total}</td><td></td></tr>"
      html +="<tr><td></td><td>#{Shop.tax_code_name}</td><td></td><td>#{number_to_currency cart.tax_amount}</td><td></td></tr>"
      html +="<tr><td></td><td>Total</td><td></td><td>#{number_to_currency cart.total}</td><td></td></tr>"
      
      html +="</table>"
      html += "</fieldset>"
      
    else
      ""
    end  
  end  
  
  def show_product_image(product, size)
    
    numImages = product.images.size
    if numImages > 0
      img = product.images[0]
      return link_to(image_tag(url_for_file_column(img, "image", size),:alt=>"Click to view large picture",:style=>"border:solid 0px #cccccc;"), :action=>'product' , :controller=>'go', :id=>product.id)
    else
      if size == "thumb"
        return image_tag("/images/no-image-32.gif")
      else
        return image_tag("/images/no-image.gif")
      end    
    end    
  end
  
  def show_product_delivery(product)
    if product.delivery == 1
      return "Yes"
    else
      return "No"
    end    
  end
  
  def show_product_condition(product)
    
    c = Productcondition.find_all_by_id(product.condition_id)
    if c.size > 0
      return c[0].condition
    else
      return "Unknown"
    end    
  end  
  
  def show_product_warranty(product)
    c = Productwarranty.find_all_by_id(product.warranty_id)
    if c.size > 0
      return c[0].warranty
    else
      return "Unknown"
    end    
  end
  
  def show_sub_categories(category, level)
    script = "<script language='JavaScript' type='text/javascript'>
  		var ajax = new Ajax.InPlaceEditor('edit-category-name-#{category.id}', 
  				'#{Shop.install_dir_name}/admin/update_ajax_category_name', 
  				{ callback: function(form, value) { 
  					return 'id=#{category.id}&field=name&nvalue=' + escape(value) }, size:16 });
  	</script>"
  	
    html = level + "<span id='edit-category-name-#{category.id}'>" + category.name + "</span> (" +
      link_to(image_tag("/images/trash.gif"), { :controller=>'categories', :action => 'delete', :id => category.id}, 
      :confirm => 'Do you want to delete category <' + category.name  +  '>? This operation will move all products in this category to root category.', :method => 'post') + 
      ")<br/>" + script
        

    if category.number_of_sub_categories > 0
      
      for sub in category.sub_categories
        html += show_sub_categories(sub, level + level)
      end
    end
    return html
  end
  
  def show_sub_categories_for_fontpage_darken(category, level, query)
    category_name = category.name
    if category.label.include?(query)
      
    else
      category_name = "<span class='darken'>" + category_name + "</span>"
    end
    
    if category.is_top_level_sub_categories
      html = level + link_to("<span class='top_category_title'>" + category_name + "</span>", :action=>'category', :id=>category, :controller=>'go') + "<br/>"
    else
      html = level + link_to(category_name, :action=>'category', :id=>category, :controller=>'go') + "<br/>"
    end    
    
    if category.number_of_sub_categories > 0
      
      for sub in category.sub_categories
        html += show_sub_categories_for_fontpage_darken(sub, level + level, query)
      end
    end
      
    return html
  end
  
  def show_sub_categories_for_fontpage_no_darken(category, level)
    
    if category.is_top_level_sub_categories
      html = level + link_to("<span class='top_category_title'>" + category.name + "</span>", :action=>'category', :id=>category, :controller=>'go') + "<br/>"
    else
      html = level + link_to(category.name, :action=>'category', :id=>category, :controller=>'go') + "<br/>"
    end    
    
    if category.number_of_sub_categories > 0
      
      for sub in category.sub_categories
        html += show_sub_categories_for_fontpage_no_darken(sub, level + level)
      end
    end
      
    return html
  end
  
  
  def show_category_structure(category, cid)
    
    if (cid == category.id)
      txt = category.name
    else
      txt = link_to(category.name, :action=>'category',:id=>category.id,:controller=>'go')
    end  
    
    if (category.has_parent_category)
      txt = show_category_structure(category.parent_category, cid) + " - " + txt
    else  
      return txt
    end
  end
  
  def show_category_structure_with_link(category)
    
    txt = link_to(category.name, :action=>'category',:id=>category.id,:controller=>'go')
    
    if (category.has_parent_category)
      txt = show_category_structure_with_link(category.parent_category) + " - " + txt
    else  
      return txt
    end
  end
  
  def text_with_br(txt)
    t = txt.gsub(/\n/,'W2Y_Br')
    t = t.gsub('&','&amp;')
    t = t.gsub('W2Y_Br', '<br/>')
    return t
  end
  
end
