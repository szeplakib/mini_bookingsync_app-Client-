class Rental
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming
  attr_accessor :name,
                :daily_rate
end
