module ProductsHelper
  def show_tax_code_name(tax_code_name,rate, incl)
    
    if rate.blank? or rate <=0 or rate >= 100
      return link_to("(Tax is not set)", :controller=>'admin', :action=>'tax')
    else
      if incl
        return link_to("(#{tax_code_name} incl.)", :controller=>'admin', :action=>'tax')
      else
        return link_to("(#{tax_code_name} excl.)", :controller=>'admin', :action=>'tax')
      end
    end
    
  end
end
