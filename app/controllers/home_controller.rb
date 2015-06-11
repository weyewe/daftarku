class HomeController < ApplicationController

  
  skip_before_filter :authenticate_user!

 
  def overview 
  	@objects = Reimburse.includes(:reimburse_details).limit(10).order("id DESC")

    redirect_to dashboard_url if current_user
  end

  def show_article
  	@object  = Reimburse.friendly.find params[:id]
  end

 
end
