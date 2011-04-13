class EventIntervLink < ActiveRecord::Base
	belongs_to :event
	belongs_to :intervenant
end
