class Entity < ActiveRecord::Base
  has_many :branches
  has_many :intervenants
end
