class UsersController < ApplicationController

  def email_validate
    email = params[:email]
    user = User.new(email: email)
    error_message = valid_on(user, :email)
    if error_message
      render_fail(error_message)
    else
      render_success
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    authorize! :update, @user
  end
end
