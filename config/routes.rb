Rails.application.routes.draw do

  root 'home#index'

  devise_for :users, controllers: {registrations: 'registrations'}
  resources :users do
    collection { post :import}
  end

  resources :courses do
      member do
          get 'home'
      end
  end
  
  get 'test_social' => 'social#index'
  get 'test_social/test' => 'social#test' 
  post 'test_social/test' => 'social#create' 

  get 'test_eneagrama' => 'psychological#index'
  get 'test_eneagrama/test' => 'psychological#test' 
  post 'test_eneagrama/test' => 'psychological#create' 

  get 'usuarios' => 'users#index'
  get 'cursos/test' => 'courses#index' 
  get 'curso/:id' => 'courses#show' 
  get 'my_courses' => 'courses#my_courses_list'

  get 'grupos' => 'groups#index'
  post  'grupos' => 'groups#index' 
  get 'mi_equipo' => 'groups#my_group'

  get 'excel' => 'groups#groups_list'

  get 'complaint' => 'groups#get_complaint'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
