class RentalsController < ApplicationController
  require 'faraday'
  include RentalsHelper

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
    response_status = response.status
    response_body = JSON.parse(response.body)
    if response_status == 201
      flash[:success] = 'Rental added successfully'
      redirect_to new_rental_path
    else
      flash[:danger] = response_body['message']
      redirect_to new_rental_path
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

  def get_rental_index()
    conn = Faraday.new(url: 'http://localhost:3000') do |c|
      c.use Faraday::Request::UrlEncoded
      c.use Faraday::Response::Logger
      c.use Faraday::Adapter::NetHttp
    end

    response = conn.get '/rentals'
    JSON.parse(response.body)
  end
end