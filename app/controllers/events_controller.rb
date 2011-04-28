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
      format.iphone { render :layout => false }
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
  
	def install_status
		myquery = <<-SQL
			select 
			  b.id as agence_id, b.name as agence_name, b.description as agence_desc, 
			  s.id as server_id, lower(s.name) as server_name, s.description as server_desc, substring(s.description from 1 for  position('-' in  s.description)-1) as serialno,
			  case 
			    when emig.done is not null then
			      'Installe & Migre'
			    when einst.done is not null then 
			      'Installe'
			    when emig.cancelled is not null then
			      'Migration abandonnee'
			    when einst.cancelled is not null then
			      'Installation abandonnee'
			    else
			      'Planifie'
			   end as status,
			  einst.planned as install_p, einst.done as install_d, einst.cancelled as install_c, coalesce(einst.cancelled, einst.done, einst.planned) as install_used,
			  emig.planned as mig_p, emig.done as mig_d, emig.cancelled as mig_c, coalesce(emig.cancelled, emig.done, emig.planned) as mig_used
			from brinks.branches b
			inner join brinks.servers s on (s.branch_id=b.id)
			left outer join brinks.events einst on (einst.eventable_type='Branch' and einst.eventable_id=b.id and einst.operation_id=4)
			left outer join brinks.events emig on (emig.eventable_type='Branch' and emig.eventable_id=b.id and emig.operation_id=3)
			where s.description not like 'IBM Model%' and
			s.alias <> ''
			order by 1 
		SQL
			
		@ope = Event.connection.select_all(myquery)
		
		respond_to do |format|
			format.html # index.html.erb
			format.xml  { render :xml => @events }
			format.iphone { render :layout => false }
			format.csv do
				filename = I18n.l(Time.now, :format => :short) + "- etat serveurs.csv"	
		      	csv_string = CSV.generate do |csv|
			        # header row
			        csv << ["Agence", "DescriptionAgc", "Serveur", "DescriptionSrv", "NoSerie", "Etat", 
			        	    "DateInstPlan", "DateInstDone", "DateInstCancel", "DateInstUsed",
			        	    "DateMigPlan", "DateMigDone", "DateMigCancel", "DateMigUsed"]
			        # data rows
			        @ope.each do |o|
			          	csv << 	[o["agence_name"],
								o["agence_desc"],			          	
								o["server_name"],			          	
								o["server_desc"],			          	
								o["serialno"],
								o["status"],
								o["install_p"],
								o["install_d"],
								o["install_c"],
								o["install_used"],
			  					o["mig_p"],
			  					o["mig_d"],
			  					o["mig_c"],
			  					o["mig_used"]]
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
      format.iphone { render :layout => false }
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
