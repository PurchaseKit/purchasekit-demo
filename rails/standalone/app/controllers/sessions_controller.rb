class SessionsController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email_address: params[:email_address])

    if user&.authenticate(params[:password])
      start_new_session_for(user)
      redirect_to after_authentication_url, notice: "Signed in successfully"
    else
      redirect_to new_session_path, alert: "Invalid email or password"
    end
  end

  def destroy
    terminate_session
    redirect_to root_path, notice: "Signed out successfully"
  end
end
