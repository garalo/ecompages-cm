######################################
# EcomPages Basic 2.0.2 (Prototype)
# Author: Robert QS
# Email: robert.q.s@gmail.com
# URL: http://www.ecompages.com/
######################################

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_shop_session_id'
  
  def paginate_collection(collection, options = {})
      default_options = {:per_page => 10, :page => 1}
      options = default_options.merge options

      pages = Paginator.new self, collection.size, options[:per_page], options[:page]
      first = pages.current.offset
      last = [first + options[:per_page], collection.size].min
      slice = collection[first...last]
      return [pages, slice]
  end
end
