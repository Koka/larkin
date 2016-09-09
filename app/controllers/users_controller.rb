class UsersController < ApplicationController
  before_action :authenticate_user, :dispatcher_only

  def show
    render json: User.find_by(id: params[:id])
  end
end
