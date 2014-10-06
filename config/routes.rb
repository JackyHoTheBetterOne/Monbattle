Rails.application.routes.draw do

devise_for :users

resources :monsters do
  resources :monster_unlocks, only: [:create, :destroy]
end

resources :monster_unlocks, only: [] do
  resources :members, only: [:create, :destroy]
end

resources :monster_skins do
  resources :monster_skin_purchases, only: [:create, :destroy]
end

resources :abilities do
  resources :ability_purchases, only: [:create, :destroy]
end

resources :personalities, only: [:create, :destroy, :edit, :index] do
  resources :thoughts, only: [:create, :destroy]
end

resources :home, only: [:index]
resources :ability_equipping_for_users, only:[:create,:update]

root 'admin#index'
resources :home
resources :admin
resources :effects
resources :parties
resources :battle_levels
resources :battles
resources :ability_equippings, only: [:create, :update]
resources :jobs, only: [:create, :destroy]
resources :elements, only: [:create, :destroy]
resources :targets, only: [:create, :destroy]
resources :stat_targets, only: [:create, :destroy]
resources :abil_sockets, only: [:create, :destroy]

resources :monster_skin_equippings, only: [:create, :destroy, :update]
resources :monster_skin_equippings, only: [:create, :destroy, :update]

# resources :summoners
# resources :summoner_levels


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
