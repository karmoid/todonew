class WelcomeController < ApplicationController
  helper :application
  include GmailsHelper
  	
  def index
    if user_signed_in?
		@data = Branch.all
    	@map = set_gmail(@data)
    end
    getevents # if iphone_user_agent?
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @data }
      format.iphone 
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
  
private

  def getevents
  	myquery = <<-SQL
  	select b1.*,
	CASE WHEN cancelled is null THEN
	  CASE WHEN done is null THEN
	    'planned'
	  else
	  	'done'   
	  END	
	ELSE 'cancelled'
    END as status  	
  from  (
SELECT 
  branches.id as branch_id, 
  branches."name" as branch_name, 
  branches.description as branch_description, 
  branches.id as target_id, 
  branches."name" as target_name, 
  branches.description as target_description, 
  entities.id as entity_id, 
  entities."name" as entity_name, 
  entities.description as entity_description, 
  operations.id as operation_id, 
  operations."name" as operation_name, 
  operations.description as operation_description, 
  opegroups.id as opegroup_id, 
  opegroups."name" as opegroup_name, 
  opegroups.description as opegroup_description, 
  events.id as id, 
  events.description as description, 
  events.planned as planned, 
  events.done as done, 
  events.cancelled as cancelled,
  coalesce(events.cancelled,events.done,events.planned) as date_used, 
  events.eventable_type
FROM 
  brinks.events, 
  brinks.branches, 
  brinks.operations, 
  brinks.opegroups, 
  brinks.entities
WHERE 
  events.eventable_id = branches.id AND
  events.operation_id = operations.id AND
  branches.entity_id = entities.id AND
  operations.opegroup_id = opegroups.id AND
  events.eventable_type = 'Branch'
union
SELECT 
  branches.id, 
  branches."name", 
  branches.description, 
  servers.id,
  servers.name,
  servers.description,
  entities.id, 
  entities."name", 
  entities.description, 
  operations.id, 
  operations."name", 
  operations.description, 
  opegroups.id, 
  opegroups."name", 
  opegroups.description, 
  events.id, 
  events.description, 
  events.planned, 
  events.done, 
  events.cancelled, 
  coalesce(events.cancelled,events.done,events.planned) as date_used, 
  events.eventable_type
FROM 
  brinks.events, 
  brinks.servers, 
  brinks.branches, 
  brinks.operations, 
  brinks.opegroups, 
  brinks.entities
WHERE 
  events.eventable_id = servers.id AND
  events.operation_id = operations.id AND
  branches.id = servers.branch_id AND
  branches.entity_id = entities.id AND
  operations.opegroup_id = opegroups.id AND
  events.eventable_type = 'Server'
union
SELECT 
  branches.id, 
  branches."name", 
  branches.description, 
  instances.id,
  instances.sid,
  instances.description,
  entities.id, 
  entities."name", 
  entities.description, 
  operations.id, 
  operations."name", 
  operations.description, 
  opegroups.id, 
  opegroups."name", 
  opegroups.description, 
  events.id, 
  events.description, 
  events.planned, 
  events.done, 
  events.cancelled, 
  coalesce(events.cancelled,events.done,events.planned) as date_used, 
  events.eventable_type
FROM 
  brinks.events, 
  brinks.instances, 
  brinks.branches, 
  brinks.operations, 
  brinks.opegroups, 
  brinks.entities
WHERE 
  events.eventable_id = instances.id AND
  events.operation_id = operations.id AND
  branches.id = instances.branch_id AND
  branches.entity_id = entities.id AND
  operations.opegroup_id = opegroups.id AND
  events.eventable_type = 'Instance'
) b1  
where opegroup_name = 'SRV_REFRESH' and 
  ((planned between '#{Date.current-12}' and '#{Date.current + 7}') or 
   (done between '#{Date.current-12}' and '#{Date.current + 7}') or 
   (cancelled between '#{Date.current-12}' and '#{Date.current + 7}')
  ) 
  order by coalesce(cancelled,done,planned) ASC, branch_name, operation_name 
  SQL
  	
  	@ope = Event.connection.select_all(myquery)
  end
  
  
end
