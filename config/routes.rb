Rails.application.routes.draw do


  scope "(:locale)" do
    resources :admintools, only: :index do
      post :clear, on: :collection
      post 'addrows', on: :collection
      post 'upload', on: :collection
      post 'upload_yaml', on: :collection
      get 'download', on: :collection
      get 'download_full', on: :collection
    end
    devise_for :users, :controllers => { invitations: 'invitations'}
    resources :entity_instances do 
      get :autocomplete, on: :collection
      get :autocomplete_type, on: :collection
      get :preview
      
    end
    resources :users

    resources :suggest_relationships

    resources :admintools
    
    resources :relationships do
      resources :relationship_bits
      get :autocomplete_type, on: :collection
      get :preview
    end

    resources :searches do
      get :search_history, on: :collection
      get :search, on: :collection
      get :root, on: :collection
      get :load_info, on: :member
    end

    get '*unmatched_route', to: 'application#raise_not_found'

  end
  root 'searches#root'

  get '/:locale' => 'searches#root'
 
  
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
