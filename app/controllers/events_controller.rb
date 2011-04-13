require 'iconv'
require 'csv'
class EventsController < ApplicationController
  before_filter :authenticate_user!
  # GET /events
  # GET /events.xml
  def index
  	@period = params[:period] || 7
  	getevents 
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
	  format.csv do
			filename = I18n.l(Time.now, :format => :short) + "- interventions.csv"	
	      	csv_string = CSV.generate do |csv|
		        # header row
		        csv << ["Id", "Description", "Groupe", "Operation", "Agence", "Serveur", "Instance", "Etat", "Date"]
		        # data rows
		        @interventions.each do |event|
					case event.eventable.class.to_s
						when "Instance" then
						  	item1 = event.eventable.branch.description
						  	item2 = event.eventable.server.name
						  	item3 = event.eventable.sid
				 		when "Server" then
						  	item1 = event.eventable.branch.description
						  	item2 = event.eventable.name
						  	item3 = ""
			  		when "Branch" then
						  	item1 = event.eventable.description
						  	item2 = ""
						  	item3 = ""
					end	  	 
		          	csv << [event.id,
            				event.description,
            				event.operation.opegroup.description,
            				event.operation.description,
            				item1, item2, item3,
            				event.date_used_desc,
            				event.date_used]
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

  def getevents
    @interventions = Event.where(
     	"(planned between :startdate and :enddate) or "+
        "(done between :startdate and :enddate) or "+
        "(cancelled between :startdate and :enddate)",
  		{:startdate => Date.current-@period.to_i, :enddate => Date.current+@period.to_i}).
  		order("coalesce(cancelled,done,planned) ASC")
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = parent.events.find(params[:id])
    @intervenants = Intervenant.all - @event.intervenants
    
    # render :action => parent.class.to_s.tableize
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = parent.events.build
    @operations = Operation.find(:all)
    parent

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = parent.events.find(params[:id])
    @operations = Operation.find(:all)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # POST /events
  # POST /events.xml
  def create
    @event = parent.events.build(params[:event])
    respond_to do |format|
      if @event.save
        format.html { redirect_to(@parent, :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(@event.eventable, :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
  	parent
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(@parent) }
      format.xml  { head :ok }
    end
  end
  
  private

  def parent
    @parent ||= case
      when params[:server_id] then Server.find(params[:server_id])
      when params[:instance_id] then Instance.find(params[:instance_id])
      when params[:branch_id] then Branch.find(params[:branch_id])
    end
  end  	
  
end
