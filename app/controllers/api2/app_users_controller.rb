class Api2::AppUsersController < Api2::BaseMobileApiController
skip_before_filter :authenticate_user_from_token!, 
          :only => [:create  ]
  skip_before_filter :ensure_authorized, 
          :only => [:create  ]
  
  respond_to :json

  def create
    @object = User.create_object( params[:user] )  
    
    
 
    if @object.errors.size == 0
      @object.ensure_authentication_token
      @object.device_id = params[:deviceToken]
      @object.save 

       
      render :json => { :success => true, 
                        :user => @object }  
    else
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg                         
    end
  end

  def update
    
    @object =  current_user 
    @object.update_object( params[:user])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :user => @object  } 
    else
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg 
    end
  end



 

end
 