class Booking
  include ActiveModel::Conversion
  extend  ActiveModel::Naming
  attr_accessor :rental_id,
                :client_email,
                :start_at,
                :end_at,
                :price
  def initialize(
    arg = {
      rental_id: nil,
      client_email: nil,
      start_at: nil,
      end_at: nil,
      price: nil
    }
  )
    @rental_id = arg[:rental_id]
    @client_email = arg[:client_email]
    @start_at = arg[:start_at]
    @end_at = arg[:end_at]
    @price = arg[:price]
  end
end
