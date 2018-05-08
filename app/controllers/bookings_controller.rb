class BookingsController < ApplicationController
  def index
    @bookings = send_booking_index_for_all_request
  end

  def show
  end

  def new
    @booking = Booking.new
    @bookings = send_booking_index_for_rental_request(rental_params[:rental_id])
  end

  def create
    response = send_create_booking(booking_params)
    if_successful_redirect(
      status: 201,
      response_status: response.status,
      err_messages: JSON.parse(response.body),
      success_text: 'Rental has been booked successfully!',
      success_path: bookings_path,
      failure_path: new_rental_booking_path
    )
  end

  def edit
    response = send_booking_show_request(params)
    @booking = Booking.new(
      start_at: JSON.parse(response.body)['start_at'][0..9].to_date,
      end_at: JSON.parse(response.body)['end_at'][0..9].to_date,
      client_email: JSON.parse(response.body)['client_email']
    )
  end

  def update
    response = send_booking_update_request(booking_params)
    if_successful_redirect(
      status: 200,
      response_status: response.status,
      err_messages: JSON.parse(response.body),
      success_text: 'Booking has been updated successfully!',
      success_path: bookings_path,
      failure_path: edit_rental_booking_path
    )
  end

  def destroy
    response = send_booking_destroy_request(params)
    if_successful_redirect(
      status: 204,
      response_status: response.status,
      err_messages: { 'message' => 'Error: ' + response.status.to_s },
      success_text: 'Booking has been removed successfully!',
      success_path: bookings_path,
      failure_path: bookings_path
    )
  end

  private

  def connect_api
    Faraday.new(url: 'http://localhost:3000') do |c|
      c.use Faraday::Request::UrlEncoded
      c.use Faraday::Response::Logger
      c.use Faraday::Adapter::NetHttp
    end
  end

  # Erről megkérdezni Danit

  def rental_params
    params.permit(:rental_id)
  end

  def booking_params
    booking_p = params.require(:booking)
    # Return this hash
    {
      start_at: join_date(
        booking_p[:'start_at(1i)'],
        booking_p[:'start_at(2i)'],
        booking_p[:'start_at(3i)']
      ),
      end_at: join_date(
        booking_p[:'end_at(1i)'],
        booking_p[:'end_at(2i)'],
        booking_p[:'end_at(3i)']
      ),
      client_email: booking_p[:client_email]
    }
  end

  def join_date(year, month, day)
    [year, month, day].join('-')
  end

  def send_booking_index_for_rental_request(rental_id)
    response = connect_api.get '/rentals/' + rental_id.to_s + '/bookings'
    JSON.parse(response.body)
  end

  def send_booking_index_for_all_request
    response = connect_api.get '/bookings'
    JSON.parse(response.body)
  end

  def send_create_booking(booking_params)
    connect_api.post(
      "/rentals/#{rental_params[:rental_id]}/bookings",
      client_email: booking_params[:client_email],
      start_at: booking_params[:start_at],
      end_at: booking_params[:end_at]
    )
  end

  def send_booking_show_request(params)
    connect_api.get "/rentals/#{params[:rental_id]}/bookings/#{params[:id]}"
  end

  def send_booking_update_request(booking_params)
    connect_api.patch(
      "/rentals/#{params[:rental_id]}/bookings/#{params[:id]}",
      start_at: booking_params[:start_at],
      end_at: booking_params[:end_at],
      client_email: booking_params[:client_email]
    )
  end

  def send_booking_destroy_request(params)
    connect_api.delete "/rentals/#{params[:rental_id]}/bookings/#{params[:id]}"
  end

  def if_successful_redirect(options)
    if options[:response_status] == options[:status]
      flash[:success] = options[:success_text]
      redirect_to options[:success_path]
    else
      flash[:danger] = options[:err_messages]['message']
      redirect_to options[:failure_path]
    end
  end
end
