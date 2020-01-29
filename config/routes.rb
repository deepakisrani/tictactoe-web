Rails.application.routes.draw do
  #get 'home/index' // get 'whatever/route' => 'controller#action' [Alternative]

  resources :game
  #get 'new-game' => 'game#new'
  #post 'start-game' => 'game#start'
  #get '/new-game/:id(.:format)' => 'game#play'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'game#index'
end
