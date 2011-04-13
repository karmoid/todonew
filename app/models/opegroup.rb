class Opegroup < ActiveRecord::Base
  has_many :operations
  has_many :events, :through => :operations
end
