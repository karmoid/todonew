require 'open_flash_chart'
class WelcomeController < ApplicationController
  helper :application
  include GmailsHelper
    	
  def index
    if user_signed_in?
        setlimits
        getevents # if iphone_user_agent?
    end
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @ope }
      format.iphone 
    end
  end
  
  def indexmap
    if user_signed_in?
		  @data = Branch.all
   	  @map = set_gmail(@data)
    end
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @data }
      format.iphone {render :action => :index}
    end
  end
  
  def stat
    @title = "Statistiques"
    respond_to do |format|
      format.html {
        if user_signed_in?
          @graph1 = open_flash_chart_object( 960, 400, '/welcome/graph_install' )
          @graph2 = open_flash_chart_object( 960, 400, '/welcome/graph_migrate' )
          @graph3 = open_flash_chart_object( 470, 400, '/welcome/pie_status' )
        end  
      } 
      format.xml  { render :xml => @data }
      format.iphone {render :action => :index}
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

  def graph_install
    rendergraph(4, "d'installations")
  end

  def graph_migrate
    rendergraph(3, "de migrations")
  end
  
  def pie_status
    renderpie
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
  ((planned between '#{@startdate}' and '#{@enddate}') or 
   (done between '#{@startdate}' and '#{@enddate}') or 
   (cancelled between '#{@startdate}' and '#{@enddate}')
  ) 
  order by coalesce(cancelled,done,planned) ASC, branch_name, operation_name 
  SQL
  	
  	@ope = Event.connection.select_all(myquery)
  end

  def getstat
    myquery = <<-SQL
      select mydate, 
      e.operation_id,
      sum(case 
        when e.planned<=mydate then 1 
        else 0
      end) as planned,  
      sum(case 
        when e.done is not null and e.done <= mydate then 1
        else 0
      end) as done,
      sum(case 
        when e.cancelled is not null and e.cancelled <= mydate then 1
        else 0
      end) as cancelled
      from (
        select distinct e.planned as mydate from brinks.events e where e.operation_id in (3,4)
        union 
        select distinct e.done as mydate  from brinks.events e where e.operation_id in (3,4)
      ) as b1
      inner join brinks.events e on (e.operation_id in (3,4))
      where mydate is not null
      group by mydate, e.operation_id
      order by mydate, e.operation_id
  SQL

    @stat = Event.connection.select_all(myquery)
      
  end  

  def getpie_now
    myquery = <<-SQL
      select 
        count(b.id) as value,        
        case 
          when emig.done is not null then
            'Installe & Migre'
          when emig.cancelled is not null then
            'Migration abandonnee'
          when einst.done is not null then 
            'Installe'
          when einst.cancelled is not null then
            'Installation abandonnee'
          else
            'Planifie'
         end as libelle
      from brinks.branches b
      inner join brinks.servers s on (s.branch_id=b.id)
      left outer join brinks.events einst on (einst.eventable_type='Branch' and einst.eventable_id=b.id and einst.operation_id=4)
      left outer join brinks.events emig on (emig.eventable_type='Branch' and emig.eventable_id=b.id and emig.operation_id=3)
      where s.description not like 'IBM Model%' and
      s.alias <> ''
      group by 2
      order by 2    
    SQL

    @stat = Event.connection.select_all(myquery)
          
  end

  def rendergraph(typestat, lib)
    caption_x = []
    dataplan = []
    datadone = []
    datacancel = []
    lastyear = nil
    lastweek = nil
    lastdate = nil
    
    getstat
    
    @stat.each do |s|
      if (s["operation_id"].to_i == typestat) && (s["mydate"].to_date > "2011-01-01".to_date)
        year = s["mydate"].to_date.cwyear
        week = s["mydate"].to_date.cweek
        while (lastyear.nil?) || (lastyear<year) || ((lastyear==year) && (lastweek<week)) do
          if lastyear.nil?
            lastyear = year
            lastweek = week
            lastdate = s["mydate"].to_date
            if lastdate.wday==0
              lastdate = lastdate - 6
            else  
              lastdate = lastdate - lastdate.wday + 1
            end 
            caption_x << lastdate.day.to_s + "-" + lastdate.month.to_s + "-" + lastdate.year.to_s
            dataplan << 0
            datadone << 0
            datacancel << 0
          elsif (lastyear<year) || ((lastyear==year) && (lastweek<week)) 
            lastdate = lastdate + 7
            lastyear = lastdate.cwyear
            lastweek = lastdate.cweek
            caption_x << lastdate.day.to_s + "-" + lastdate.month.to_s + "-" + lastdate.year.to_s
            dataplan << dataplan.last
            datadone << datadone.last
            datacancel << datacancel.last
          end  
        end
        if (lastyear==year) && (lastweek == week) 
            dataplan[dataplan.length-1] = s["planned"].to_i
            datadone[datadone.length-1] = s["done"].to_i
            datacancel[datacancel.length-1] = s["cancelled"].to_i
        end 
      end       
    end


    # based on this example - http://teethgrinder.co.uk/open-flash-chart-2/data-lines-2.php
    title = Title.new("Etats des #{lib.split(" ").last.split("'").last}")

    line_dot = Line.new
    line_dot.text = "Planifie"
    line_dot.width = 4
    line_dot.colour = '#DFC329'
    line_dot.dot_size = 5
    line_dot.values = dataplan

    line_hollow = Bar.new
    line_hollow.text = "Realise"
    line_hollow.width = 1
    line_hollow.colour = '#6363AC'
    line_hollow.dot_size = 5
    line_hollow.values = datadone

    line = Bar.new
    line.text = "Abandonne"
    line.width = 1
    line.colour = '#FF3333'
    line.dot_size = 5
    line.values = datacancel
     
     
    tmp = []
    
    x_labels = XAxisLabels.new
    x_labels.visible_steps = 2
    x_labels.rotate = -90

    caption_x.each do |text|
      tmp << XAxisLabel.new(text, '#0000ff', 12, '')
    end

    x_labels.labels = tmp

    x = XAxis.new
    x.set_labels(x_labels)

    y = YAxis.new
    y.set_range(0,70,5)

    x_legend = XLegend.new("Semaines")
    x_legend.set_style('{font-size: 20px; color: #778877}')

    y_legend = YLegend.new("Nombre #{lib}")
    y_legend.set_style('{font-size: 20px; color: #770077}')

    chart = OpenFlashChart.new
    chart.set_title(title)
    chart.set_x_legend(x_legend)
    chart.set_y_legend(y_legend)
    chart.x_axis = x
    chart.y_axis = y

    chart << line_hollow
    chart << line
    chart << line_dot

    render :text => chart.to_s
  end
  
  def renderpie
    
    getpie_now
    
    # based on this example - http://teethgrinder.co.uk/open-flash-chart-2/data-lines-2.php
    title = Title.new("Bilan")

    pie = Pie.new
    pie.start_angle = 35
    pie.animate = true
    pie.tooltip = '#val# sur #total#<br>#percent#%'
    pie.colours = ["#d01f3c", "#356aa0", "#C79810","#ee0099","#ccff11"]

    tmp = []
    @stat.each do |s|
      tmp << PieValue.new(s["value"].to_i, s["libelle"])
    end
    pie.values  = tmp
    
    chart = OpenFlashChart.new
    chart.title = title
    chart.add_element(pie)

    chart.x_axis = nil

    render :text => chart.to_s
  end
  
end
