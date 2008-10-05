######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################

## TODO: Admin functions to fill email data

class OrderMailer < ActionMailer::Base

  def confirm(order)
    @subject    = "#{Shop.shop_name} Order Confirmation"
    @body["order"]       = order
    @recipients = order.email
    @from       = Shop.admin_email
    @sent_on    = Time.now
  end

  def formmessage(name, email, phone, note)
    @subject    = 'Message from website visitor'
    @body["note"]       = note
    @body["name"]       = name
    @body["email"]       = email
    @body["phone"]       = phone
    
    @recipients = Shop.admin_email
    @from       = Shop.admin_email
    @sent_on    = Time.now
  end
  
  def ordernotice(order)
    @subject    = 'New Order'
    @body["order"]       = order
    @recipients = Shop.admin_email
    @from       = Shop.admin_email
    @sent_on    = Time.now
  end
  
  def accountnew(user)
    @subject    = 'Your #{Shop.shop_name} account'
    @body["user"]       = user
    @recipients = user.email
    @from       = Shop.admin_email
    @sent_on    = Time.now
  end
  
  def sendall(account, subject, body)
    @subject    = subject
    @body["account"]       = account
    @body["body"]       = body
    @recipients = account.email
    @from       = Shop.admin_email
    @sent_on    = Time.now
  end
  
  def statusnotice(order)
    @subject    = 'Order Status has been updated'
    @body["order"]       = order
    @recipients = order.email
    @from       = Shop.admin_email
    @sent_on    = Time.now
  end
  
end
