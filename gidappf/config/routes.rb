Rails.application.routes.draw do
  resources :roles
  root 'pages#home'
end
