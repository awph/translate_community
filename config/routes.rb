TranslateCommunity::Application.routes.draw do

  devise_for :users
  get "profile_page/index"
  get "submitted_translations/index"
  get "submitted_projects/index"
  get "submitted_projects/submitted_projects"
  get "submitted_translations/translations"
  get "profile_page/profile"
  # http://weblog.jamisbuck.org/2007/2/5/nesting-resources

  root to: 'projects#index'

  resources :users do
    resources :projects#, :name_prefix => "user_"
  end

  resources :projects do
    resources :items#, :name_prefix => "project_"
    put :upload_items, on: :member
  end

  resources :items, only: [:show, :edit, :update, :destroy] do
    resources :translations#, :name_prefix => "item_"
  end

  resources :translations
  
  resources :profile_page
  resources :submitted_projects
  resources :submitted_translations
  # resources :users do
  #   resources :projects do
  #     resources :items do
  #       resources :translations
  #     end
  #   end
  # end

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
