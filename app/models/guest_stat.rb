class GuestStat < ApplicationRecord

  serialize :profile, JSON
  serialize :heroes, JSON

end
