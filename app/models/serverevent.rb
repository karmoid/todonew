class Serverevent < ActiveRecord::Base
  belongs_to :server, :class_name => "Server"
  belongs_to :event, :class_name => "Event"  
end
