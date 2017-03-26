Rails.application.routes.draw do
  root to: 'home#index'
  get '/photos', to: 'photos#index'

  resources :rsvps,
    path: 'rsvp',
    constraints: { id: /enter_code|attendance|food|confirmation|wicked_finish/ }

  namespace :admin do
    resources :foods
    resources :people
    resources :rsvp_codes

    root to: "foods#index"
  end

  if !Rails.env.development?
    match "/404", :to => "errors#not_found", :via => :all
    match "/500", :to => "errors#internal_server_error", :via => :all
  end
end
