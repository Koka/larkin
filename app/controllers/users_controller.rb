class UsersController < ApplicationController
  before_action :authenticate_user, :dispatcher_only
  skip_before_action :dispatcher_only, only: [:me]

  def show
    render json: User.find(params[:id])
  end

  def me
    render json: current_user
  end
end
