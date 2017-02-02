Rails.application.routes.draw do
  resources :rsvps,
    path: 'rsvp',
    constraints: { id: /enter_code|attendance|food|confirmation|wicked_finish/ }
end
