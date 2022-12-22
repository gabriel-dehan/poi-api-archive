class V1::PerksController < ApplicationController
  access_level :public

  def index 
    # TODO (L): If current user is part of an organisation, he might have different perks
    @perks = Perk.all.page(params[:page]).per(params[:per_page] || 20)
  end
end
