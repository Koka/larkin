Rails.application.routes.draw do
  get '/', to: redirect('/app')
  post 'knock/auth_token', to: 'user_token#create'
  mount_ember_app :frontend, to: "/app"

  get 'users/me', to: 'current_user#index'
  get 'users/:id', to: 'users#show', as: 'users_show'

  get 'orders', to: 'orders#index', as: 'orders_list'
  get 'orders/:id', to: 'orders#show', as: 'orders_show'
  put 'orders/:id', to: 'orders#update', as: 'orders_update'
  post 'orders/schedule', to: 'orders#schedule', as: 'orders_schedule'
  post 'orders', to: 'orders#upload', as: 'orders_upload'
  post 'orders/:id/split', to: 'orders#split', as: 'orders_split'
  post 'orders/:id/move_up', to: 'orders#move_up', as: 'orders_move_up'
  post 'orders/:id/move_down', to: 'orders#move_down', as: 'orders_move_down'

  get 'trucks', to: 'trucks#index', as: 'trucks_list'
  get 'trucks/:id', to: 'trucks#show', as: 'trucks_show'
  get 'trucks/:id/shift_available/:shift/:date', to: 'trucks#shifts', as: 'trucks_shifts'

  get 'routelists', to: 'routelists#index', as: 'routelists_list'
  get 'routelists/:id', to: 'routelists#show', :defaults => { :format => 'json' }, as: 'routelists_show'
  get 'routelists/:id/stops', to: 'routelists#stops', as: 'routelists_stops'
end
