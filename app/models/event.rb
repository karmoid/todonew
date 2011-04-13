class Event < ActiveRecord::Base
  has_event_calendar :start_at_field  => 'planned', :end_at_field => 'planned'  
  belongs_to :operation
  belongs_to :eventable, :polymorphic => true
  has_many :event_interv_links
  has_many :intervenants, :through => :event_interv_links
  
    def branch_indirect
  		return eventable if eventable.class.to_s == "Branch"
  		return eventable.branch
    end
  
    def branch_indirect_id
  		return eventable.id if eventable.class.to_s == "Branch"
  		return eventable.branch.id
    end
  
  	def name
  		return operation.short_name
  	end
  
    def color
    	col = operation.cal_color
    	return "#99FF00" if col.nil?
    	return col
    end  
  
	def date_used
	  	return cancelled unless cancelled.nil?
	  	return done unless done.nil?
	  	return planned
	end
    
    def date_used_desc
	  	return "Abandonne" unless cancelled.nil?
	  	return "Realise" unless done.nil?
	  	return "Planifie"
    end
  
	def start_at
		return planned
	end
	
	def start_at=(value)
		planned = value
	end  

	def end_at
		return done unless done.nil?
		return cancelled unless cancelled.nil?
		return planned
	end
	def end_at=(value)
		done = value
	end  
end
