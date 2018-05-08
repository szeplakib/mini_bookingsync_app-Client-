class RentalsController < ApplicationController
  require 'faraday'
  include RentalsHelper

  def book_a_rental
    @rentals = send_rental_index_request
  end

  def index
    @rentals = send_rental_index_request
  end

  def show
    response = send_rental_show_request(params)
    @rental = JSON.parse(response.body)['rental']
    @bookings = JSON.parse(response.body)['bookings']
  end

  def new
    @rental = Rental.new
  end

  def create
    response = send_create_rental_request(rental_params)
    if_successful_redirect(
      status: 201,
      response_status: response.status,
      err_messages: JSON.parse(response.body),
      success_text: 'Rental has been successfully created!',
      success_path: new_rental_path,
      failure_path: new_rental_path
    )
  end

  def edit
    response = send_rental_show_request(params)
    @rental = Rental.new(
      name: JSON.parse(response.body)['rental']['name'],
      daily_rate: JSON.parse(response.body)['rental']['daily_rate']
    )
  end

  def update
    response = send_rental_update_request(params) # Ezt meg meg kéne nezni
    if_successful_redirect(
      status: 200,
      response_status: response.status,
      err_messages: JSON.parse(response.body),
      success_text: 'Rental has been updated successfully!',
      success_path: rentals_path,
      failure_path: edit_rental_path
    )
  end

  def destroy
    response = send_rental_destroy_request(params) # Ezt meg meg kéne nezni
    if_successful_redirect(
      status: 204,
      response_status: response.status,
      err_messages: { 'message' => 'Error: ' + response.status.to_s },
      success_text: 'Rental has been removed successfully!',
      success_path: rentals_path,
      failure_path: rentals_path
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

  def rental_params
    params.require(:rental).permit(:name, :daily_rate)
  end

  def send_create_rental_request(rental_params)
    connect_api.post(
      '/rentals',
      name: rental_params[:name],
      daily_rate: rental_params[:daily_rate]
    )
  end

  def send_rental_show_request(params)
    connect_api.get "/rentals/#{params[:id]}"
  end

  def send_rental_destroy_request(params)
    connect_api.delete "/rentals/#{params[:id]}"
  end

  def send_rental_update_request(params)
    connect_api.patch(
      "/rentals/#{params[:id]}",
      name: rental_params[:name],
      daily_rate: rental_params[:daily_rate]
    )
  end

  def send_rental_index_request()
    response = connect_api.get '/rentals'
    JSON.parse(response.body)
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
