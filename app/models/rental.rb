class Rental
  include ActiveModel::Conversion
  extend  ActiveModel::Naming
  attr_accessor :name,
                :daily_rate
  def initialize(name: nil, daily_rate: nil)
    @name = name
    @daily_rate = daily_rate
  end
end
