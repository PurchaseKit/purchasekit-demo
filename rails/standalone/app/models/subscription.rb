class Subscription < ApplicationRecord
  belongs_to :user

  scope :active, -> { where(status: "active") }

  enum :status, {
    active: "active",
    canceled: "canceled",
    expired: "expired"
  }
end
