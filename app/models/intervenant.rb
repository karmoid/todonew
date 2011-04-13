class Intervenant < ActiveRecord::Base
	has_many :event_interv_links
	has_many :events, :through => :event_interv_links
	belongs_to :entity  
end
