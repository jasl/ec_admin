EcAdmin::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users

  resources :instances do
    #get 'page/:page', :action => :index, :on => :collection

    get 'clear' => 'instances#clear'
    get 'backup' => 'instances#backup'
    get 'reset_passwd' => 'instances#reset_passwd'
    match 'recovery/:backup_record_id' => 'instances#recovery', :via => :post, :as => 'recovery'

    match 'backup_records' => 'backup_records#index', :via => :get
  end
  match 'instances/clear' => 'instances#clear', :via => :post, :as => 'clear_instances'
  match 'instances/backup' => 'instances#backup', :via => :post, :as => 'backup_instances'
  match 'instances/recovery' => 'instances#recovery', :via => :post, :as => 'recovery_instances'
  match 'instances/reset_passwd' => 'instances#reset_passwd', :via => :post, :as => 'reset_passwd_instances'

  resources :backup_records, :except => [:new, :create] do
    #get 'page/:page', :action => :index, :on => :collection

    get 'fetch', :to => 'backup_records#fetch'
  end

  get "main/index"
  get "main/dashboard"

  root :to => 'main#index'

end
