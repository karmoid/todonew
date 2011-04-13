class Branch < ActiveRecord::Base
  has_many :servers 
  has_many :instances
  belongs_to :entity
  has_many :events, :as => :eventable
end
