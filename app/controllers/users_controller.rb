class UsersController < ApplicationController
  before_action :authenticate_user, :dispatcher_only

  def show
    render json: User.find(params[:id])
  end
end
