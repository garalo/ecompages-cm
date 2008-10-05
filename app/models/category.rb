######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################

class Category < ActiveRecord::Base
  
  def before_destroy
    # delete sub categories
    for sub in self.sub_categories
      sub.destroy
    end  
  end
  
  def number_of_sub_categories
    num = Category.find(:all, :conditions=>["p_id = ?", self.id]).length
    return num
  end
  
  def is_top_level_sub_categories
    if self.p_id == 1
      return true
    else
      return false
    end    
  end
  
  def sub_categories
    Category.find(:all, :conditions=>["p_id = ?", self.id],:order=>"name")
  end
  
  def self.top_level_categories
    return Category.find(:all, :conditions=>["p_id = 1 and id != 1", 1,1], :order=>'level_order')
  end
  
  def parent_category
    pc = Category.find(self.p_id)
    return pc
  end
  
  def has_parent_category
    if self.p_id == 0
      return false
    else
      return true
    end    
  end
  
  def print_structure
    txt = self.name
    if (has_parent_category)
      txt = parent_category.print_structure + "->" + txt
    else  
      return txt
    end
  end
  
  def products
    
    return Product.find_all_by_category_id(self.id)
  end
  
  ## TODO: This works only when the number of
  ##       category levels is less than 4
  def self.level_in_the_tree(category)
    if category.is_top_level_sub_categories
      return 2
    else
      return 3
    end
  end
  
  def self.cal_level_num(category)
    10**(level_in_the_tree(category))
  end
end