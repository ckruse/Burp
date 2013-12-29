Burp::Application.routes.draw do
  devise_for :authors, :path => "admin", path_names: { sign_in: 'login', sign_out: 'logout', password: 'password' }

  get "/:year/:mon/:slug" => "posts#show", year: /\d{4}/, mon: /[a-z]{3}/
  get "/:year/:mon/:slug" => "posts#update", year: /\d{4}/, mon: /[a-z]{3}/

  get '/tags' => 'tags#index', as: :tags
  get '/tags/:tag' => 'tags#show', as: :tag

  get '/archive' => 'archive#years', as: :archive
  get '/archive/:year' => 'archive#months', as: :archive_year
  get '/archive/:year/:month' => 'archive#posts', as: :archive_month

  get '/feed' => 'posts#index', as: 'feed'

  root to: "posts#index"

  get 'admin', to: redirect('/admin/comments')
  namespace :admin do
    resources :comments, except: [:new, :create]
    resources :posts

    post '/comments/batch_action' => 'comments#batch_action', as: :batch_action
    post '/comments/:id/hidden' => 'comments#hidden', as: :comment_hidden
    post '/comments/:id/visible' => 'comments#visible', as: :comment_visible
  end

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
