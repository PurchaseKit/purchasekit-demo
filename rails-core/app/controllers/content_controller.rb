class ContentController < ApplicationController
  require_authorization only: :paid

  def free
  end

  def paid
  end
end
