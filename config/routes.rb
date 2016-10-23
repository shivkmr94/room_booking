Rails.application.routes.draw do
  root :to => 'user/bookings#index'
  devise_for :users
  
  # in admin namespace all resources are use for admin
  namespace :admin do
  	resources :users, :room_types, :rooms, :bookings
  end  

  namespace :user do
    resources :bookings
  end

  namespace :api do
    namespace :v1 do
      resources :bookings, :tokens, :room_types, defaults: {format: 'json'}
    end
  end   
  
end
