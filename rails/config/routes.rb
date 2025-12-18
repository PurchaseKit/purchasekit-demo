Rails.application.routes.draw do
  # Mount PurchaseKit::Pay engine
  mount PurchaseKit::Pay::Engine, at: "/purchasekit", as: "purchasekit_pay"

  resource :session, only: [:new, :create, :destroy]
  resource :dashboard, only: :show
  resource :paywall, only: :show

  get "free", to: "content#free"
  get "paid", to: "content#paid"

  resource :configuration, only: [], constraints: {format: :json} do
    get :ios, on: :member
    get :android, on: :member
  end

  post "webhooks/apple", to: "apples#create"

  root "dashboards#show"
end
