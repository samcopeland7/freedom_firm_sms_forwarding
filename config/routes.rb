Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :twilio do
    post '/', to: 'switchboard#reroute'
    post 'help', to: 'messages#help'
    post 'welcome', to: 'messages#welcome'
    post 'stop', to: 'messages#stop'
    post 'forward', to: 'messages#forward'
  end

  resources :subscribers

end
