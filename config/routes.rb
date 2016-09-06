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
  post 'orders', to: 'orders#upload'

  get 'trucks', to: 'trucks#index'
  get 'trucks/:id', to: 'trucks#show'

  get 'routelists', to: 'routelists#index'
  get 'routelists/:id', to: 'routelists#show'
end
