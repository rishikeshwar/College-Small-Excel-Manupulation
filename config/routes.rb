Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    get 'sessions/create'

  get 'sessions/destroy'
    
  get 'loadstats' => 'users#loadstats'
  get 'loaddata' => 'users#loaddata'
  get 'loadfac' => 'users#loadfac'
  
  resources :journals
  resources :users do 
      get 'newJournal' => :newJournal
      post 'newJournal' => :createJournal
  end

  get 'admin' => 'admin#index'
  controller :sessions do
  	get 'login' => :new
  	post 'login' => :create
  	delete 'logout' => :destroy
  end

  root 'sessions#new'
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
