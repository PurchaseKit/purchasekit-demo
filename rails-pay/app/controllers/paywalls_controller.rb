class PaywallsController < ApplicationController
  before_action :ensure_payment_processor

  def show
    @annual = PurchaseKit::Product.find("prod_3VC24F5M")
    @monthly = PurchaseKit::Product.find("prod_28VWPCQ7")
  end

  def restore
    if Current.user.subscribed?
      redirect_to paid_path, notice: "Your subscription is active."
    else
      redirect_to paywall_path, alert: "No active subscription found."
    end
  end

  private

  def ensure_payment_processor
    unless Current.user.payment_processor
      Current.user.set_payment_processor(:purchasekit)
    end
  end
end
