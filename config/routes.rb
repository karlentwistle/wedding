Rails.application.routes.draw do
  resources :rsvps,
    path: 'rsvp',
    constraints: { id: /enter_code|attendance|food|confirmation|wicked_finish/ }

  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all
end
