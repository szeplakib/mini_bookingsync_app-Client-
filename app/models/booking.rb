class Booking
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming
  attr_accessor :rental_id,
                :email,
                :start_at,
                :end_at,
                :price
end