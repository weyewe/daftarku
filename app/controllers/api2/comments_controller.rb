class Api2::CommentsController < Api2::BaseMobileApiController

  respond_to :json
  


  def create

    @reimburse_detail  = ReimburseDetail.find_by_id( params[:comment][:reimburse_detail_id])
    if @reimburse_detail.nil?  
      render :json => { :success => false , :no_record_found => true }  
      return 
    end


    @reimburse = @reimburse_detail.reimburse 

    if   not @reimburse.is_associated_with?(current_user)
    	render :json => { :success => false , :no_record_found => true }  
      return 
    end
    params[:comment][:user_id] = current_user.id

    @object = Comment.create_object( params[:comment] )  
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :comment => @object  }  
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
 