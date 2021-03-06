Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :password_resets, except: %i(index show destroy)
    resources :users do
      collection do
        resources :changes_password, only: %i(edit update)
      end
    end

    resources :morning_speech_schedule, except: %i(edit)
  end
end
