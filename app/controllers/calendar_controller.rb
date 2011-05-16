class CalendarController < ApplicationController
  before_filter :authenticate_user!

    def index
      @opegroups = Opegroup.find(:all, :order => :description)
	  # params[:event][:opegroup_ids] ||= []       
	  # params[:opegroup][:id] ||= []
      @sellist = @opegroups.map {|o| [o.description ,o.id]}
	  @sellist << ["Tous les projets" , -1]
	         
      @month = (params[:month] || Time.zone.now.month).to_i
      @year = (params[:year] || Time.zone.now.year).to_i

      @shown_month = Date.civil(@year, @month)

      @first_day_of_week = 1
      params[:info] ||= "-1" 
      idg = params[:info].to_i
      if idg < 0
        @current_selection = @sellist[@sellist.length-1][0]
        @event_strips = Event.event_strips_for_month(@shown_month, @first_day_of_week)
      else      	
        @current_selection = Opegroup.find(idg).description
        @event_strips = Event.event_strips_for_month(@shown_month, @first_day_of_week, :include => :operation, :conditions => ["operations.opegroup_id = :opegroup" , {:opegroup => idg}])
      end
    end
    
    def day
      @day = (params[:day] || Time.zone.now.day).to_i
      @month = (params[:month] || Time.zone.now.month).to_i
      @year = (params[:year] || Time.zone.now.year).to_i
	  @seldate = Date.new(@year, @month, @day)
	  geteventscal(@seldate, @seldate)    	
    end
    
private

  def getevents
  	@interventions = Event.where(
     	"(planned = :startdate) or "+
        "(done = :startdate) or "+
        "(cancelled = :startdate)",
  		{:startdate => @seldate}).
  		order("eventable_type ASC, eventable_id ASC, coalesce(cancelled,done,planned) ASC")
  end

  def geteventscal(debut, fin)
    maquery = <<-SQL
      select e.id, e.description, e.operation_id, e.note, b2.dateref as planned, e.done, e.cancelled, e.status, e.created_at, e.updated_at, e.eventable_id, e.eventable_type, e.all_day
        from brinks.events as e,
        (select DATE '#{debut}' + id * interval '1 day' dateref from generate_series(0,31) as id) as b2
        where (b2.dateref between '#{debut}' and '#{fin}') and
              ((e.planned<=b2.dateref) and (b2.dateref <= coalesce(cancelled,done,planned)))
        order by b2.dateref ASC, eventable_id
        SQL
    @interventions = Event.find_by_sql(maquery)
  end  
    
  end
