class UsersController < ApplicationController
  def show
    @guy = User.find params[:id]
    render
  end
end