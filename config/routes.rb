Rails.application.routes.draw do

devise_for :users

root 'admin#index'
resources :admin

resources :monsters, only: [:create, :edit, :update, :destroy] do
  resources :members, only: [:create, :destroy]
  resources :monster_unlocks, only: [:destroy]
end
resources :monster_skins, only: [:create, :edit, :update, :destroy] do
  resources :monster_skin_purchases, only: [:create, :destroy]
end

resources :effects, only: [:create, :edit, :update, :destroy]
resources :abilities, only: [:create, :edit, :update, :destroy]
resources :parties, only: [:create, :edit, :update, :destroy]
resources :battle_levels, only: [:create, :edit, :update, :destroy]
resources :battles
# get 'monsters/clone' => 'monsters#clone', as: :monster_clone
patch 'monsters/evolve/edit/:id' => 'monsters#evolve_edit', as: :evolve_edit
resources :jobs, only: [:create, :destroy]
resources :elements, only: [:create, :destroy]
resources :targets, only: [:create, :destroy]
resources :stat_targets, only: [:create, :destroy]

resources :monster_skin_equippings, only: [:create, :destroy, :update]
resources :ability_equippings, only: [:create, :destroy, :update]
resources :monster_skin_equippings, only: [:create, :destroy, :update]
resources :monster_unlocks, only: [:create]
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
