Rails.application.routes.draw do
  get '/', to: redirect('/app')

  get 'users/me', to: 'current_user#index'
  post 'knock/auth_token', to: 'user_token#create'

  mount_ember_app :frontend, to: "/app"

  get 'orders', to: 'orders#index'
  get 'orders/:id', to: 'orders#show'
  put 'orders/:id', to: 'orders#update'
  post 'orders', to: 'orders#upload'

  get 'trucks', to: 'trucks#index'
  get 'trucks/:id', to: 'trucks#show'
end
