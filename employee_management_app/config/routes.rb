Rails.application.routes.draw do
  root "employees#index"
  resources :employees
  resources :managers, except: :show
  resources :departments, except: :show
end
