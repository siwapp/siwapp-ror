Rails.application.routes.draw do

  root 'dashboard#index'

  get    'login'   => 'sessions#new',      as: :login
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy',  as: :logout

  resources :taxes, :series, :payments, :templates


  get "invoices/amounts"
  get "recurring_invoices/amounts"
  get "items/amount"

  resources :invoices do
    delete 'remove', on: :collection
    post 'bulk', on: :collection
    post 'select_template', on: :member
    get 'autocomplete', on: :collection
    get 'chart_data', on: :collection
    get 'send_email', on: :member
  end

  get 'invoices/template/:id/invoice/:invoice_id', to: 'invoices#template'

  resources :recurring_invoices do
    post 'generate', on: :collection
    delete 'remove', on: :collection
    get 'chart_data', on: :collection
  end

  resources :customers do
    get 'autocomplete', on: :collection
  end

  post 'templates/set_default', to: 'templates#set_default'
  post 'series/set_default', to: 'series#set_default'
  post 'taxes/set_default', to: 'taxes#set_default'

  get 'settings/global'
  post 'settings/global'
  get 'settings/profile'
  post 'settings/profile'
  get 'settings/smtp'
  post 'settings/smtp'

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
