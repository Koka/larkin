Rails.application.routes.draw do
  get '/', to: redirect('/app')
  post 'knock/auth_token', to: 'user_token#create'
  mount_ember_app :frontend, to: "/app"

  get 'users/me', to: 'current_user#index'
  get 'users', to: 'users#index'
  get 'users/:id', to: 'users#show'

  get 'orders', to: 'orders#index'
  get 'orders/:id', to: 'orders#show'
  put 'orders/:id', to: 'orders#update'
  put 'orders/:id/schedule', to: 'orders#schedule'
  post 'orders', to: 'orders#upload'
  post 'orders/:id/split', to: 'orders#split'
  post 'orders/:id/move_up', to: 'orders#move_up'
  post 'orders/:id/move_down', to: 'orders#move_down'

  get 'trucks', to: 'trucks#index'
  get 'trucks/:id', to: 'trucks#show'
  get 'trucks/:id/shift_available/:shift/:date', to: 'trucks#shifts'

  get 'routelists', to: 'routelists#index'
  get 'routelists/:id', to: 'routelists#show', :defaults => { :format => 'json' }
  get 'routelists/:id/stops', to: 'routelists#stops'
end
