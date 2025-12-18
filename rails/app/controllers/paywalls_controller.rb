class PaywallsController < ApplicationController
  before_action :ensure_payment_processor

  def show
  end

  private

  def ensure_payment_processor
    unless Current.user.payment_processor
      Current.user.set_payment_processor(:purchasekit)
    end
  end
end
