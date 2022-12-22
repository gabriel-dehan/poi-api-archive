class V1::UsersController < ApplicationController
  access_level :public, only: [:count]
  access_level :private, only: [:show, :index, :user_applications]
  # internal_only true, except: [:count] 
  skip_before_action :authenticate_user!, only: [:count, :index, :show]

  def count 
    @users = User.all
  end

  # Index is only private access
  def index 
    @users = User.all

    # if has_internal_access?
    #   @users = @users.map do |user| 
    #     # TODO: Do not force, and check in the observer if the token is nil, make a request
    #     user.ensure_internal_auth_token(true)
    #     user
    #   end
    # end

    render json: { data: @users }
  end

  # Show is only private access
  def show 
    @user = User.find(params[:id])

    # if has_internal_access?
    #   @user.ensure_internal_auth_token(true)
    # end
    
    # binding.pry
    render json: { data: @user }
  end
end
