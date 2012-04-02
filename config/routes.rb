EcAdmin::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users

  resources :instances do
    get 'page/:page', :action => :index, :on => :collection
  end
  match 'instances/:id/clear' => 'instances#clear', :via => :get, :as => 'clear_instance'
  match 'instances/:id/backup' => 'instances#backup', :via => :get, :as => 'backup_instance'
  match 'instances/:id/reset_passwd' => 'instances#reset_passwd', :via => :get, :as => 'reset_passwd_instance'
  post 'instances/clear' => 'instances#clear'
  post 'instances/backup' => 'instances#backup'
  post 'instances/reset_passwd' => 'instances#reset_passwd'

  get "main/index"
  get "main/dashboard"

  root :to => 'main#index'

end
