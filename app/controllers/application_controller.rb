class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :authenticate_user!

  # def after_sign_in_path_for(resource)
  #   tenant_outstanding_invoice_url 
  # end

  # def after_sign_out_path_for( resource )
  # 	root_url
  # end


  def after_sign_in_path_for( user ) 
    my_reimburse_url 
  end

 
  

  protect_from_forgery with: :exception
end
