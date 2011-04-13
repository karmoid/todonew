class Server < ActiveRecord::Base
  belongs_to :branch
  has_many :instances
  has_many :events, :as => :eventable
end
