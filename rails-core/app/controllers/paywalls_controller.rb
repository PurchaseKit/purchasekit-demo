class PaywallsController < ApplicationController
  def show
    @annual = PurchaseKit::Product.find("prod_3VC24F5M")
    @monthly = PurchaseKit::Product.find("prod_28VWPCQ7")
  end
end
