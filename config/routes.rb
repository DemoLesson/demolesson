Preview::Application.routes.draw do
  #Warning: make sure user URL can't be set to any of these
  
  #Actions
  match 'signup', :to => 'users#create', :as => 'signup'
  match 'login', :to => 'users#login', :as => 'login'
  match 'logout', :to => 'users#logout', :as => 'logout'
  match 'verify', :to => 'users#verify', :as => 'verify'
  match 'forgot_password', :to => 'users#forgot_password', :as => 'forgot_password'
  match 'change_password', :to => 'users#change_password', :as => 'change_password'  
  match 'update_settings' => 'users#update_settings'
  match 'choose_stored', :to => 'users#choose_stored', :as => 'choose_stored'
  match 'change_picture', :to => 'users#change_picture'
  match 'create_profile', :to => 'teachers#create_profile'

  # Beta
  root :to => "home#index"
  match 'beta_teacher' => "alphas#teacher"
  match 'beta_admin' => "alphas#admin"
  match 'beta_general' => "alphas#general"
  
  # Account/Teacher
  match 'account/:id' => 'users#edit'
  match 'add_pin' => 'teachers#add_pin'
  match 'remove_pin' => 'teachers#remove_pin'
  match 'add_star' => 'teachers#add_star'
  match 'remove_star' => 'teachers#remove_star'
  match 'purge/:id' => 'teachers#purge'
  match 'users' => 'users#update'
  match 'attach' => 'teachers#attach'
  match 'videos/record' => 'videos#record'
  
  match 'education', :to => 'teachers#education'
  match 'update_education' => 'teachers#update_education'
  match 'remove_education/:id' => 'teachers#remove_education'
  
  match 'experience', :to => 'teachers#experience'
  match 'update_experience' => 'teachers#update_experience'
  match 'remove_experience/:id' => 'teachers#remove_experience'
  match 'fetch_code' => 'users#fetch_code'
  
  get "home/index"

  resources :jobs do 
    get :auto_complete_search, :on => :collection
  end
  
  resources :alphas
  resources :winks
  resources :reviews
  resources :jobs
  resources :applications
  resources :review_permissions
  resources :schools
  resources :teachers
  resources :videos
  resources :users

  resources :blogentries

  resources :pins
  resources :subjects
  resources :credentials
  resources :blog_entries
  resources :messages

  match '/:url', :to => 'teachers#profile'
  
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
