require 'iconv'
require 'csv'
class ServersController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /servers
  # GET /servers.xml
  def index
    @servers = Server.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @servers }
	  format.csv do
			filename = I18n.l(Time.now, :format => :short) + "- servers.csv"	
	      	csv_string = CSV.generate do |csv|
		        # header row
		        csv << ["Id", "Name", "Description", "Alias", "Agence", "Entite"]
		
		        # data rows
		        @servers.each do |server|
		          csv << [  server.id,
            				server.name,
            				server.description,
            				server.alias,
            				server.branch.description,
            				server.branch.entity.description]
		        end
			end
		# csv_string = BOM + Iconv.conv("utf-16le", "utf-8", csv_string)
	    # send it to the browsah
	    send_data csv_string,
	                :type => 'text/csv; charset=utf-8; header=present',
	                :disposition => "attachment;",
	                :filename => filename
		end    
	end
  end

  # GET /servers/1
  # GET /servers/1.xml
  def show
    @server = Server.find(params[:id])
    @interventions = @server.events.order("coalesce(cancelled,done,planned) ASC")

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @server }
    end
  end

  # GET /servers/new
  # GET /servers/new.xml
  def new
    @server = Server.new
    @branches = Branch.find(:all)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @server }
    end
  end

  # GET /servers/1/edit
  def edit
    @server = Server.find(params[:id])
    @branches = Branch.find(:all)
  end

  # POST /servers
  # POST /servers.xml
  def create
    @server = Server.new(params[:server])

    respond_to do |format|
      if @server.save
        format.html { redirect_to(@server, :notice => 'Server was successfully created.') }
        format.xml  { render :xml => @server, :status => :created, :location => @server }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @server.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /servers/1
  # PUT /servers/1.xml
  def update
    @server = Server.find(params[:id])

    respond_to do |format|
      if @server.update_attributes(params[:server])
        format.html { redirect_to(@server, :notice => 'Server was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @server.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /servers/1
  # DELETE /servers/1.xml
  def destroy
    @server = Server.find(params[:id])
    @server.destroy

    respond_to do |format|
      format.html { redirect_to(servers_url) }
      format.xml  { head :ok }
    end
  end
end
