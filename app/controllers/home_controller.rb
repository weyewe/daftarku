class HomeController < ApplicationController

  
  skip_before_filter :authenticate_user!

 
  def overview 
    redirect_to dashboard_url if current_user
  end

 
end
