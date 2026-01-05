Rails.application.routes.draw do
  # Mount PurchaseKit engine
  mount PurchaseKit::Engine, at: "/purchasekit", as: "purchasekit"

  resource :session, only: [:new, :create, :destroy]
  resource :dashboard, only: :show
  resource :paywall, only: :show do
    post :restore, on: :member
  end

  get "free", to: "content#free"
  get "paid", to: "content#paid"

  resource :configuration, only: [], constraints: {format: :json} do
    get :ios, on: :member
    get :android, on: :member
  end

  root "dashboards#show"
end
