Rails.application.routes.draw do

resources :notices

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
resources :ability_purchases, only: [:create, :edit]

post "/facebook" => "battles#new"
get "/cannot" => "home#illegal_access", as: :illegal
get "/home" => "home#index", as: :battle_preparation
get "/store" => "home#store", as: :device_store
get "/landing" => "home#facebook", as: :home_sweet_home


root 'home#facebook'
get 'home/roll_trash' => "home#roll_trash", as: :roll_trash
get 'home/roll_treasure' => "home#roll_treasure", as: :roll_treasure

resources :home
resources :admin
resources :effects
resources :parties
resources :battle_levels
resources :users

resources :battles do
  collection do
    get :generate_field
  end
end

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
