Rails.application.routes.draw do
  get '/', to: redirect('/app')
  post 'knock/auth_token', to: 'user_token#create'
  mount_ember_app :frontend, to: "/app"

  resources :users, only: [:show] do
    collection do
      get 'me'
    end
  end

  resources :orders, only: [:index, :show, :update] do
    collection do
      post 'upload'
      post 'schedule'
    end

    member do
      post 'split'
      post 'move_up'
      post 'move_down'
    end
  end

  resources :trucks, only: [:index, :show] do
    member do
      get 'shift_available/:shift/:date', action: 'shift_available', as: 'shift_available'
    end
  end

  get 'routelists', to: 'routelists#index', as: 'routelists_list'
  get 'routelists/:id', to: 'routelists#show', :defaults => { :format => 'json' }, as: 'routelists_show'
  get 'routelists/:id/stops', to: 'routelists#stops', as: 'routelists_stops'
end
