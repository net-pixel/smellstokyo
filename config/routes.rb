Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root 'products#home'
  resources :products do
    collection do
      get 'searchFromHeadersForm'
      get 'searchFromPulldownsForm'
      get 'indexOfWomenProducts'
      get 'indexOfMenProducts'
    end
  end
  resources :products do
    resources :comments, only: :create
  end
  resources :users, only: :show
end