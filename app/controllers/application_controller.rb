class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :adjust_format_for_iphone
  helper_method :iphone_user_agent?
  
protected
	def adjust_format_for_iphone
	# iPhone sub-domain request
	# request.format = :iphone if iphone_subdomain?
	# Detect from iPhone user-agent
		request.format = :iphone if iphone_user_agent?
	end
	
	# Request from an iPhone or iPod touch?
	# (Mobile Safari user agent)
	def iphone_user_agent?
		request.env["HTTP_USER_AGENT" ] &&
		request.env["HTTP_USER_AGENT" ][/(Mobile\/.+Safari)/]
	end
	
	def iphone_subdomain?
		return request.subdomains.first == "iphone"
	end
end
