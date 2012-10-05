DataEngineering::Application.routes.draw do
	devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :uploads
  root :to => "uploads#index"
end
