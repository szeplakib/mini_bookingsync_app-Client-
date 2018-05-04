class BookingsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @booking = Booking.new
    @bookings = get_booking_index(rental_params[:rental_id])
  end

  def create
    response = send_create_booking(booking_params)
    response_status = response.status
    response_body = JSON.parse(response.body)
    if response_status == 201
      flash[:success] = 'Booking added successfully'
      redirect_to new_rental_booking_path
    else
      flash[:danger] = response_body['message']
      redirect_to new_rental_booking_path
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

private

  def rental_params
    params.permit(:rental_id)
  end

  def booking_params
    booking_p = params.require(:booking)
    {
      start_at: join_date(booking_p[:'start_at(1i)'], booking_p[:'start_at(2i)'], booking_p[:'start_at(3i)']),
      end_at: join_date(booking_p[:'end_at(1i)'], booking_p[:'end_at(2i)'], booking_p[:'end_at(3i)']),
      client_email: booking_p[:client_email]
    }
  end

  def join_date(year, month, day)
  [year, month, day].join('-')
  end

  def get_booking_index(rental_id)
    conn = Faraday.new(url: 'http://localhost:3000') do |c|
      c.use Faraday::Request::UrlEncoded
      c.use Faraday::Response::Logger
      c.use Faraday::Adapter::NetHttp
    end

    response = conn.get '/rentals/' + rental_id.to_s + '/bookings'
    JSON.parse(response.body)
  end

  def send_create_booking(booking_params)
    conn = Faraday.new(url: 'http://localhost:3000') do |c|
      c.use Faraday::Request::UrlEncoded
      c.use Faraday::Response::Logger
      c.use Faraday::Adapter::NetHttp
    end
    conn.post "/rentals/#{rental_params[:rental_id]}/bookings",
                                    {
                                      client_email: booking_params[:client_email],
                                      start_at: booking_params[:start_at],
                                      end_at: booking_params[:end_at]
                                    }
  end
end
