Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'dashboard#index'

  get    'login'   => 'sessions#new',      as: :login
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy',  as: :logout

  post 'test' => 'hooks#test'

  get  'taxes/get_defaults', to: 'taxes#get_defaults'

  resources :taxes, :templates, :series

  get "invoices/amounts"
  get "recurring_invoices/amounts"
  get "items/amount"

  resources :commons do
    post 'select_print_template', on: :member
  end
  resources :invoices do
    post 'bulk', on: :collection
    post 'select_print_template', on: :member
    get 'autocomplete', on: :collection
    get 'chart_data', on: :collection
    get 'send_email', on: :member
    get 'print', on: :member
  end

  resources :recurring_invoices do
    post 'generate', on: :collection
    delete 'remove', on: :collection
    get 'chart_data', on: :collection
  end

  resources :customers do
    get 'autocomplete', on: :collection
    resources :invoices, only: [:index]
    resources :recurring_invoices, only: [:index]
  end

  post 'templates/set_default', to: 'templates#set_default'
  post 'series/set_default', to: 'series#set_default'
  post 'taxes/set_default', to: 'taxes#set_default'

  get 'settings/global'
  put 'settings/global', to: 'settings#global_update'
  get 'settings/profile'
  put 'settings/profile', to: 'settings#profile_update'
  get 'settings/tags'
  put 'settings/tags', to: 'settings#tags_update'
  get 'settings/hooks'
  put 'settings/hooks', to: 'settings#hooks_update'
  get 'settings/api_token'
  post 'settings/api_token'


  # API
  namespace :api do
    namespace :v1 do
      get 'invoices/print_template/:id/invoice/:invoice_id', to: 'commons#print_template', as: :rendered_template
      get 'stats', to: 'invoices#stats'
      resources :taxes, :series, only: [:index, :create, :show, :update, :destroy], defaults: { format: :json}
      resources :customers, only: [:index, :create, :show, :update, :destroy], defaults: { format: :json} do
        resources :invoices, only: [:index] # for filtering
      end
      resources :payments, only: [:show, :update, :destroy], defaults: {format: :json}
      resources :items, only: [:show, :update, :destroy], defaults: {format: :json} do
        resources :taxes, only: [:index], defaults: { format: :json}
      end

      resources :invoices, only: [:index, :create, :show, :update, :destroy, :send_email], defaults: { format: :json} do
        get 'send_email', on: :member
        resources :items, :payments, only: [:index, :create]
      end

      get 'recurring_invoices/generate_invoices', to: 'recurring_invoices#generate_invoices'
      resources :recurring_invoices, only: [:index, :create, :show, :update, :destroy], defaults: { format: :json} do
        resources :items, only: [:index, :create]
      end
    end
  end

  localized do
    resources :invoices, :recurring_invoices, :customers, :settings
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
