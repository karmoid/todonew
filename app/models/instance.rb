class Instance < ActiveRecord::Base
  belongs_to :environment
  belongs_to :branch
  belongs_to :server
  has_many :events, :as => :eventable
end
