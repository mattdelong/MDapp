Venuescout::Application.routes.draw do
  
  root :to => 'home#index'
  devise_for :users

  
  resources :users, :only => [:index, :show] do
  	resources :venues
  end
  
  resources :venues

  match '/user', :to => 'users#show'
  match '/users', :to => 'users#index'
  
  resources :rfps
  
  #match 'my/profile' => 'users#show', :via => :get
end
