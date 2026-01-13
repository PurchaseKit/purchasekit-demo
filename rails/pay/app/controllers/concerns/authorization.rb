module Authorization
  extend ActiveSupport::Concern

  included do
    helper_method :authorized?
  end

  class_methods do
    def require_authorization(**options)
      before_action :authorize, **options
    end
  end

  private

  def authorize
    authorized? || redirect_to(paywall_path)
  end

  def authorized?
    Current.user&.subscribed?
  end
end
