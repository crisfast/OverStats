class UserStat < ApplicationRecord
  serialize :achievements, JSON
  serialize :profile, JSON
  serialize :heroes, JSON
  
  belongs_to :user
end
