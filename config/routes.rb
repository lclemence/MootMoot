Mootmoot::Application.routes.draw do
  devise_for :users

  root :to => "home#index"
  match 'facebook' => 'home#fb_auth'

  match 'gallery-data' => 'galleries#view'

  namespace :admin do
    root :to => 'dashboard#index'

    resources :pictures
    
    resources :galleries
    
    resources :constants

    resources :users

    match 'upload' => 'pictures#upload'
    
    match 'editparams' => 'admin#editparams'
    
    match 'picturestogallery' => 'galleries#add_pictures_to_gallery'
  end
    
  devise_scope :user do
    get "/logout" => "devise/sessions#destroy"
  end
end
