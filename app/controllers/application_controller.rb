class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :iphone_user_agent?
  before_filter :adjust_format_for_iphone
  before_filter :iphone_login_required
  
protected

	# Request from an iPhone or iPod touch? (Mobile Safari user agent)
	def iphone_user_agent?
  		(request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]) || iphone_request?
	end
	
	def adjust_format_for_iphone
	# iPhone sub-domain request
	# request.format = :iphone if iphone_subdomain?
	# Detect from iPhone user-agent
		request.format = :iphone if iphone_user_agent?
	end

# Force all iPhone users to login
  def iphone_login_required
  	if iphone_request?
      redirect_to new_user_session_path unless (user_signed_in? || params[:controller]=="devise/sessions")
    end
  end

  # Return true for requests to iphone.trawlr.com
  def iphone_request?
    return (request.subdomains.first == "iphone" || params[:format] == "iphone")
  end
  	
end
