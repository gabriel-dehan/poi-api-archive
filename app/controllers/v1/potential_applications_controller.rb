class V1::PotentialApplicationsController < ApplicationController
  access_level :public

  def index
    @potential_applications = PotentialApplication.all.page(params[:page]).per(params[:per_page] || 20)
  end

  def create
    name, category, url = require_params!(:name, :category, :url)
    check_param!(:category) { |cat| Application::Categories.include?(cat) }

    @potential_application = PotentialApplication.find_or_create_by!(name: name, category: category) do |app|
      app.url = url
    end
  end

  def vote
    id = require_params!(:id)
    @vote = @user.applications_votes.find_or_create_by!(potential_application_id: id)
  end

  def unvote
    id = require_params!(:id)
    vote = @user.applications_votes.find_by(potential_application_id: id)

    raise ParamsError.new(I18n.t("errors.applications.votes.not_found", id: id)) unless vote

    vote.destroy!

    head :no_content
  end

  def update_wishlist
    papps_ids = require_params!(:apps_wishlist)

    @user.applications_votes.where.not(potential_application_id: papps_ids).destroy_all
    @user.applications_votes.create!(
      papps_ids.map { |id| { potential_application_id: id } }
    )

    @potential_applications = PotentialApplication.all

    render :index
  end
end
