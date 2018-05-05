class Rental
  include ActiveModel::Conversion
  extend  ActiveModel::Naming
  attr_accessor :name,
                :daily_rate
  def initialize(arg = {name: nil, daily_rate: nil})
    @name = arg[:name]
    @daily_rate = arg[:daily_rate]
  end
end
