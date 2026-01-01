Rails.application.routes.draw do
  # Mount PurchaseKit engine (auto-integrates with Pay when present)
  mount PurchaseKit::Engine, at: "/purchasekit", as: "purchasekit"

  resource :session, only: [:new, :create, :destroy]
  resource :dashboard, only: :show
  resource :paywall, only: :show

  get "free", to: "content#free"
  get "paid", to: "content#paid"

  resource :configuration, only: [], constraints: {format: :json} do
    get :ios, on: :member
    get :android, on: :member
  end

  root "dashboards#show"
end
