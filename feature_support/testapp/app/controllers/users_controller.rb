class UsersController < ApplicationController
  def show
    @user = User.find params[:id]
    render
  end
end