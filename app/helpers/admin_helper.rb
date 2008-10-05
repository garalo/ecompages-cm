module AdminHelper
  
  def show_suspended_status(acct)
    if acct.suspended == 1
      return "is Suspended"
    else
      return "is Actived"
    end    
  end
  
  
  
end
