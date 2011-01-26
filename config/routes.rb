Opac::Application.routes.draw do

  match '/signups/compute' => 'signups#compute'
  
  match '/dashboard' => 'dashboard#show'

  match '/auth/:provider/callback' => 'authentications#create'

  get "stock/show"

  devise_for :users, :path => 'accounts', :controllers => {:registrations => 'registrations'}

  match '/auth/failure' => 'Ibtrs#index'

  match 'ibtrs/search' => 'ibtrs#search'
  match 'ibtrs/lookup' => 'ibtrs#lookup'
  match 'ibtrs/sort' => 'ibtrs#sort', :method => :post
  match 'ibtrs/stats' => 'ibtrs#stats'
  match 'ibtrs_update' => 'ibtrs#titleupd', :method => :post
  match 'consignments/booksearch' => 'consignments#booksearch'
  match 'consignments/:id/transition/:event' => 'consignments#transition'

  resources :titles, :authors, :ibtrs, :branches, :stock, :stockitems, :authentications, :signups, :plans, :coupons, :consignments, :goods
  
  match 'statistics/:title_id' => 'statistics#view'
  
  resources :stock_racks_shelves, :ib_assignments
  match 'ibt_pick_req' => 'ib_assignments#pick'
  match 'ibt_unpick_req' => 'ib_assignments#unpick'
  match 'ibt_change_criteria' => 'ib_assignments#change'
  match 'ibt_print' => 'ib_assignments#print'
  match 'ibt_assigned' => 'ib_assignments#change'

  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "Dashboard#show"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
