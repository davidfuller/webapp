ActionController::Routing::Routes.draw do |map|
  map.resources :cross_channel_priorities

  map.resources :aspects

  map.resources :statuses

  map.resources :promos, :collection => { :last_use => :get }

  map.resources :media_types

  map.resources :priorities

  map.resources :series_numbers

  map.resources :series_numbers

  map.resources :schedule_comparisons, :collection => { :delete_all_schedule_comparisons => :delete }

  map.resources :schedule_files

  map.resources :schedule_lines

  map.resources :schedule_tab_settings

  map.resources :countdown_ipps

  map.resources :media_files, :collection => { :unready => :get, :last_use => :get }

  map.resources :media_folders

  map.resources :commons

  map.resources :jpegs

  map.resources :jpeg_folders

  map.resources :bugs

  map.resources :press_filenames

  map.resources :playlist_filenames

  map.resources :channels

  map.resources :languages

  map.resources :houses

  map.resources :titles

  map.resources :ignores

  map.resources :comparisons
  
  map.resources :press_lines, :collection => { :priority => :get, :cross_channel_selection => :get }

  map.resources :playlist_lines

  map.resources :playlist_position_settings

  map.resources :press_tab_settings

  map.resources :uploads
  
  map.resources :previews

  map.resources :preview_jpegs  
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  map.root :controller => "previews"
  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
