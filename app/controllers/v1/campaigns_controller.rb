class V1::CampaignsController < ApplicationController
  access_level :public 

  def index 
    @campaigns = Campaign.all.page(params[:page]).per(params[:per_page] || 20)
  end
end
