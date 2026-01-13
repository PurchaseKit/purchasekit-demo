class User < ApplicationRecord
  pay_customer

  has_secure_password

  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def subscribed?
    Pay::Subscription.joins(:customer)
      .where(pay_customers: {owner: self})
      .where(status: "active")
      .exists?
  end
end
