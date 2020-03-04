Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #MVP - Access to the dashboad
  get 'dashboard', to: 'pages#dashboard'

  # MVP - Create a garden and plots into the garden
  resources 'gardens', only: [:new, :create] do
    resources 'plots', only: [:new, :create]
  end

  # MVP- Update and destroy plots
  resources 'plots', only: [:update, :edit, :destroy] do
    #MVP - create plants inside a plot
    resources 'plants', only: [:create]
  end
  #MVP - Watering see the all the watering, and update the amount
  resources 'waterings', only: [:index, :show, :update]
  #MVP - Mark the plants as watered
  patch 'waterings/:id/complete', to: 'waterings#mark_as_complete'

  # MVP - Destroy plants
  resources 'plants', only: [:destroy]

  #MVP - Tasks index | IMPORTANT create update and destroy (the creation)
  resources 'tasks', only: [:index, :create, :edit, :update, :destroy]

  #MVP - Mark task as complete
  patch 'tasks/:id/complete', to: 'tasks#mark_as_complete'

  #IMPORTANT - mark a plot as watered
  patch 'plots/:id/complete_waterings', to: 'plots#complete_watering'

  #IMPORTANT - See current weather, forecast and alerts
  resources 'weather_stations', only: [:show]

  #NICE TO HAVE - Display all conversations and create a message
  resources 'conversations', only: [:index, :show] do
    resources 'messages', only:[:create]
  end

  #NICE TO HAVE - Display all users
  get 'users', to: 'users#index'

  #NICE TO HAVE - See one user and create a new conversation with it
  get 'users/:user_id', to: 'users#show' do
    resources 'conversations', only: [:new, :create]
  end

end
