class WelcomeController < ApplicationController
include Gmails	
  def index
    if user_signed_in?
		@data = Branch.all
    	@map = set_gmail(@data)
    end
  end
  
  def sample_ajax
  	@branch = Branch.find(params[:id])
    respond_to do |format|
      format.html { render :layout => false}
      format.xml  { render :xml => @branch }
    end
  end	
   
  def account
    
  end
  
end
