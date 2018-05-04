class RentalsController < ApplicationController
  require 'faraday'
  include RentalsHelper

  def book_a_rental
    @rentals = get_rental_index
  end

  def index
    @rentals = get_rental_index
  end

  def show
  end

  def new
    @rental = Rental.new
  end

  def create
    response = send_create_rental(rental_params)
    if_successful_redirect(
      {
        status: 201,
        response_status: response.status,
        err_messages: JSON.parse(response.body),
        success_text: 'Rental successfully created!',
        success_path: new_rental_path,
        failure_path: new_rental_path
      }
    )
  end

  def edit
    response = send_show_rental(params)
    @rental = Rental.new
    @rental.name = JSON.parse(response.body)['name']
    @rental.daily_rate = JSON.parse(response.body)['daily_rate'] # ez a resz okadek
  end

  def update
    response = send_update_rental(params) # Ezt meg meg kéne nezni
    if_successful_redirect(
      {
        status: 204,
        response_status: response.status,
        err_messages: { 'message' => 'Error: ' + response.status.to_s },
        success_text: 'Rental updated successfully!',
        success_path: rentals_path,
        failure_path: rentals_path
      }
    )
  end

  def destroy
    response = send_destroy_rental(params) # Ezt meg meg kéne nezni
    if_successful_redirect(
      {
        status: 204,
        response_status: response.status,
        err_messages: { 'message' => 'Error: ' + response.status.to_s },
        success_text: 'Rental removed successfully!',
        success_path: rentals_path,
        failure_path: rentals_path
      }
    )
  end


private

  def rental_params
    params.require(:rental).permit(:name, :daily_rate)
  end

  def send_create_rental(rental_params)
    conn = Faraday.new(url: 'http://localhost:3000') do |c|
      c.use Faraday::Request::UrlEncoded
      c.use Faraday::Response::Logger
      c.use Faraday::Adapter::NetHttp
    end
    conn.post '/rentals',
                                     { 
                                      name: rental_params[:name],
                                      daily_rate: rental_params[:daily_rate]
                                      }
  end

  def send_show_rental(params)
    conn = Faraday.new(url: 'http://localhost:3000') do |c|
      c.use Faraday::Request::UrlEncoded
      c.use Faraday::Response::Logger
      c.use Faraday::Adapter::NetHttp
    end
    conn.get "/rentals/#{params[:id]}"
  end

  def send_destroy_rental(params)
    conn = Faraday.new(url: 'http://localhost:3000') do |c|
      c.use Faraday::Request::UrlEncoded
      c.use Faraday::Response::Logger
      c.use Faraday::Adapter::NetHttp
    end
    conn.delete "/rentals/#{params[:id].to_s}"
  end

  def send_update_rental(params)
    conn = Faraday.new(url: 'http://localhost:3000') do |c|
      c.use Faraday::Request::UrlEncoded
      c.use Faraday::Response::Logger
      c.use Faraday::Adapter::NetHttp
    end
    conn.patch "/rentals/#{params[:id].to_s}",
                                      { 
                                      name: rental_params[:name],
                                      daily_rate: rental_params[:daily_rate]
                                      }
  end

  def get_rental_index()
    conn = Faraday.new(url: 'http://localhost:3000') do |c|
      c.use Faraday::Request::UrlEncoded
      c.use Faraday::Response::Logger
      c.use Faraday::Adapter::NetHttp
    end

    response = conn.get '/rentals'
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