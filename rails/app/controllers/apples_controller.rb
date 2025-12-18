class ApplesController < ApplicationController
  skip_forgery_protection
  allow_unauthenticated_access

  def create
    File.open("webhook.json", "wb") do |file|
      file << params.to_json
    end
    head :ok
  end
end
