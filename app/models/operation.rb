class Operation < ActiveRecord::Base
  belongs_to :opegroup
  has_many :events
end
