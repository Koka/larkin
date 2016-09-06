class UsersController < ApplicationController
  def index
    render json: User.all
  end

  def show
    render json: User.find_by(id: params[:id])
  end
end
