class V1::ApplicationsController < ApplicationController
  access_level :public
  skip_before_action :authenticate_user!, if: :has_private_access?, only: [:index]

  def index 
    category = params[:category]
    @applications = Application.all
    if category
      check_param!(:category) { |cat| Application::Categories.include?(cat) }

      @applications = @applications.where(category: category)
    end
    @applications = @applications.page(params[:page]).per(params[:per_page] || 50)    
  end

  def show 
    @application = Application.find(params[:id])
  end

  def connected_users 
    @application = Application.find(params[:id])
    @users_connections = @application.connected_applications
  end

  def categories 
    @categories = Application.all.pluck(:category).uniq
  end

end
