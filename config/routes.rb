Rails.application.routes.draw do
  root 'static_pages#home'
  get 'static_pages/home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/book_a_rental', to: 'rentals#book_a_rental'
  get '/bookings', to: 'bookings#index'
  resources :rentals do
    resources :bookings, only: %i[new create]
  end
end