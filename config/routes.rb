Venuescout::Application.routes.draw do
  
devise_for :users
  
  root :to => 'users#home'

  resources :users do
    resources :planners
    resource  :venue
  end

  resources :venues,     	:only => :index
  resources :planners do
    resources :messages,    :only => :create, :as => :comments
    resources :proposals,   :only => [:new, :edit, :create, :update]
    member do
      get  'attach_user', :as => :attach_user_to
      post 'attach_user', :as => :attach_user_to
      get  'update_user', :as => :update_user_in
      post 'update_user', :as => :update_user_in
      get  'detach_user', :as => :detach_user_from
      post 'detach_user', :as => :detach_user_from
    end
  end

  match 'planners/:id/profile_details' => 'planners#profile_details',         :via => :get,    :as => :planner_profile_details
  match 'planners/:id/profile_team'    => 'planners#profile_team',            :via => :get,    :as => :planner_profile_team
  match 'planners/:id/photos'          => 'planners#photos',                  :via => :get,    :as => :planner_photos
  match 'planners/:id/upload_photos'   => 'planners#upload_photos',           :via => :get,    :as => :planner_upload_photos

  match 'u/:username'                  => 'users#show',                       :via => :get,    :as => :username

  match 'my/profile'                   => 'users#show',                       :via => :get
  match 'my/home'                      => 'users#home',                       :via => :get
  match 'my/private_messages'          => 'messages#send_private_message',    :via => :post,   :as => :my_private_messages
  match 'my/private_messages/:id'      => 'messages#show_private_message',    :via => :get,    :as => :my_private_message
  match 'my/private_messages/:id'      => 'messages#reply_private_message',   :via => :post,   :as => :my_private_message
  match 'my/private_messages/:id'      => 'messages#archive_private_message', :via => :delete, :as => :my_private_message
  match 'my/message_inboxes(/:type)'   => 'users#message_inboxes',            :via => :get,    :as => :my_message_inbox
  match 'my/micro_posts'               => 'users#add_micro_post',             :via => :post

  match 'my/follow/:target_id'         => 'users#follow_target',              :via => :post,   :as => :follow_target
  match 'my/unfollow/:target_id'       => 'users#unfollow_target',            :via => :post,   :as => :unfollow_target

end
