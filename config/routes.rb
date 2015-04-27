Rails.application.routes.draw do
  
resources :notices

resources :areas

resources :regions do 
  resources :areas
end

resources :quests

resources :cut_scenes

devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

resources :users

resources :charges

resources :monsters do
  resources :monster_unlocks, only: [:create, :destroy]
end

resources :monster_unlocks, only: [] do
  resources :member_for_users, only:[:create, :destroy]
  resources :members, only: [:create, :destroy]
end

resources :monster_skins, except: [:destroy] do
  resources :monster_skin_purchases, only: [:create, :destroy]
end

resources :personalities, only: [:create, :destroy, :edit, :index] do
  resources :thoughts, only: [:create, :destroy]
end

resources :ability_equipping_for_users, only:[:update]
resources :abilities, except: [:destroy]
resources :ability_purchases, only: [:create, :update]

root 'home#facebook'
get "/cannot" => "home#illegal_access", as: :illegal
get "/home" => "home#index", as: :battle_preparation
post "/facebook" => "home#facebook"
get "/store" => "home#store", as: :device_store
get "/landing" => "home#facebook", as: :home_sweet_home
get "/forum" => "home#forum", as: :home_forum
get "/equip_filter" => "home#equip_filter", as: :equip_filter
get "/learn_ability" => "home#learn_ability", as: :learn_ability
get "/create_battle" => "battles#create", as: :create_battle
get 'home/abilities_for_mon' => "home#abilities_for_mon"
get 'home/roll_trash' => "home#roll_trash", as: :roll_trash
get 'home/roll_treasure' => "home#roll_treasure", as: :roll_treasure
get 'ascend_monster' => 'home#ascend_monster', as: :ascend_monster
post 'unlock_ascension' => 'home#unlock_ascension', as: :unlock_ascension
get 'enhance_monster' => 'home#enhance_monster', as: :enhance_monster
post 'track_currency_pick' => "home#track_currency_pick"
post 'track_currency_purchase' => "home#track_currency_purchase"      
get 'event_areas' => 'home#event_levels'
post 'add_request_token' => 'home#add_request_token'
post 'add_accepted_request' => 'home#add_accepted_request'
get 'check_permission' => 'home#check_permission'
get 'giving_daily_reward' => 'home#give_daily_reward'
post 'notification_action' => 'home#notification_action'
post 'notification_sending' => 'home#notification_sending'

get 'guild_gate' => 'guilds#gate', as: :guild_gate
get 'guild_leave' => 'guilds#guild_leave', as: :leave_guild

get 'dick_fly' => 'home#dick_fly'

get 'guild_battle_selection' => 'gbattle#selection', as: :gbattle_listing
get 'guild_leadership_board' => 'gbattle#guild_leadership_board', as: :guild_leadership
get 'guild_battle_area_levels' => 'gbattle#guild_battle_area_levels', as: :guild_levels
get 'guild_individual_leadership_board' => 'gbattle#individual_leadership_board', as: :guild_individual_leadership


resources :home
resources :admin
resources :effects
resources :parties
resources :battle_levels
resources :users

resources :guilds do 
  post :check_name_uniqueness, on: :collection
  post :kick_member, on: :collection
end



resources :battles do
  patch :showing, on: :member
  get :win, on: :member
  get :loss, on: :member
  get :tracking_abilities, on: :member
end

resources :unlock_codes do 
  post :unlock, on: :collection
  post :unlock_by_username, on: :collection
  post :unlock_all_by_username, on: :collection
end

# match '/auth/facebook/setup', :to => 'home#ask_permission'

resources :ability_equippings, only: [:create, :update]
resources :rarities, only: [:create, :destroy]
resources :jobs, only: [:create, :destroy]
resources :elements, only: [:create, :destroy]
resources :targets, only: [:create, :destroy]
resources :stat_targets, only: [:create, :destroy]
resources :abil_sockets, only: [:create, :destroy]
resources :monster_skin_equippings, only: [:create, :destroy, :update]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
