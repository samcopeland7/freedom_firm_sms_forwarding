Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :twilio do
    post '/', to: 'messages#handle'
    # post 'help', to: 'messages#help'
    # post 'stop', to: 'messages#stop'
    # post 'forward', to: 'messages#forward'
    # post 'subscribe', to: 'messages#subscribe'
  end

  resources :subscribers

end
