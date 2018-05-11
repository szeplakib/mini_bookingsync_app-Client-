class Booking
  include ActiveModel::Conversion
  extend  ActiveModel::Naming
  attr_accessor :id,
                :rental_id,
                :client_email,
                :start_at,
                :end_at,
                :price
  def initialize(
      id: nil,
      rental_id: nil,
      client_email: nil,
      start_at: nil,
      end_at: nil,
      price: nil
  )
    @id = id
    @rental_id = rental_id
    @client_email = client_email
    @start_at = start_at
    @end_at = end_at
    @price = price
  end
end
