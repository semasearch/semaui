class UsersController < ApplicationController
  
  before_action :set_user, only: :show
  authorize_resource

  def index
    @users = User.confirmed
    @invited_users = User.unconfirmed
  end

  def show
    @searches = @user.searches
  end

  def edit
  end

  def update
  end

  def destroy
  end


  private
    def set_user
      @user = User.find(params[:id])
    end

end
