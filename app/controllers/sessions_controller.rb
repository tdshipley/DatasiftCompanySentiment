class SessionsController < ApplicationController
  skip_before_action :authenticate

  def new
  end

  def create
    user = User.find_by_name(params[:name])

    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to sentiment_new_path
    else
      redirect_to login_path, alert: 'Invalid username / password'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end
