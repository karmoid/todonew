Toudoux::Application.routes.draw do
  resources :intervenants

  resources :operations

  resources :opegroups

  get "events/index"
  get "events/install_status"
  get "events/period/:period" => "events#index"
  get "events/newcal"

  get "test_it/index"

  get "welcome/account"
  get "welcome/indexmap"
  get "welcome/stat"
  get "welcome/graph_install"
  get "welcome/graph_migrate"
  get "welcome/pie_status"
  match "welcome/sample_ajax/:id" => "welcome#sample_ajax"

  match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
  match '/calendar(/:year(/:month(/:day)))' => 'calendar#day', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/}
  
  resources :entities

  resources :environments

  resources :instances do
  	  resources :events do
 	  	resources :intervenants, :controller => "event_interv_links"
  	  end
  end

  resources :servers do
  	  resources :events do
  	  	resources :intervenants, :controller => "event_interv_links" 
	  end
  end

  resources :branches do
  	  resources :events do
  	  	resources :intervenants, :controller => "event_interv_links"
  	  end
  end

  get "welcome/index"

  devise_for :users

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
  root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
