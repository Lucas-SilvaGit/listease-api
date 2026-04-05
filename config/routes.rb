Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      post "auth/google", to: "auth#google"
      post "auth/register", to: "auth#register"
      post "auth/login", to: "auth#login"
      get "profile", to: "profiles#show"

      resources :lists, except: [ :new, :edit ] do
        post :duplicate, on: :member

        resources :items, controller: "list_items", except: [ :new, :edit, :show ] do
          patch :toggle_purchased, on: :member
          patch :update_price, on: :member
          patch :update_quantity, on: :member
          delete :remove_purchased, on: :collection
        end
      end

      resources :products, except: [ :new, :edit, :show ] do
        collection do
          get :search
        end
      end
    end
  end
end
