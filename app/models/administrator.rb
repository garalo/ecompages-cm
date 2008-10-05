######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################

class Administrator < ActiveRecord::Base
  
  def try_to_login
    Administrator.login(self.username, self.password)
  end
	
  def self.login(username, password)
    find(:first, :conditions=>["username = ? AND password = ?", username, password])
  end
end
