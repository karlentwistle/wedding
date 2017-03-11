Rails.application.routes.draw do
  get '/photos', to: 'photos#index'

  resources :rsvps,
    path: 'rsvp',
    constraints: { id: /enter_code|attendance|food|confirmation|wicked_finish/ }

  if !Rails.env.development?
    match "/404", :to => "errors#not_found", :via => :all
    match "/500", :to => "errors#internal_server_error", :via => :all
  end
end
