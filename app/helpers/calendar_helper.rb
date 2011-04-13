module CalendarHelper
    def month_link(month_date)
      link_to(I18n.localize(month_date, :format => "%B"), {:month => month_date.month, :year => month_date.year, :info => params[:info]})
    end

    # custom options for this calendar
    def event_calendar_options
      {
        :year => @year,
        :month => @month,
        :event_strips => @event_strips,
        :first_day_of_week => @first_day_of_week,
        :use_all_day => true,
        :link_to_day_action => "day",
        :month_name_text => I18n.localize(@shown_month, :format => "%B %Y"),
        :previous_month_text => "<< " + month_link(@shown_month.prev_month),
        :next_month_text => month_link(@shown_month.next_month) + " >>"
      }
    end

    def event_calendar
      calendar event_calendar_options do |args|
        # event = args[:event]
        # %(<a href="/events/#{event.id}" title="#{h(event.name)}">#{h(event.name)}</a>)
		event, day = args[:event], args[:day]
    	#html = %(<a href="/branches/#{event.branch_indirect_id}" title="#{h(event.branch_indirect.description)}">)
    	#html << %(#{h(event.branch_indirect.name)}</a>)
    	#html << %(&nbspc;)
    	html = %(<a href="/#{event.eventable.class.to_s.tableize.downcase}/#{event.eventable_id}/events/#{event.id}") 
    	html << %(title="#{h(event.date_used_desc)}\n#{h(event.operation.opegroup.description)} - #{h(event.operation.description)}\n#{h(event.note)}">)
    	html << display_event_time(event, day)
    	html << %(#{h(event.name)} #{h(event.branch_indirect.name)}</a>)
    	html        
      end
    end
end
