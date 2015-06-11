class Api2::ReimbursesController < Api2::BaseMobileApiController
   respond_to :json
  # this action is special => anyone with association is allowed to view
  def homepage
 
    current_user_id = current_user.id 
    
    @objects = Reimburse.joins(:reimburse_associations => [:user]).references(:all).where{
      (reimburse_associations.user_id.eq current_user_id ) & 
      (reimburse_associations.association_status.not_eq  ASSOCIATION_STATUS[:source]) & 
      (is_submitted.eq true )
      }.order("id DESC")

    
  end
  
  
  # if the user open his page (reimburse list) 
  def index
    @objects = Reimburse.where(:user_id => current_user.id).order("id DESC")
  end

  def create
    params[:reimburse][:user_id] = current_user.id 
    @object = Reimburse.create_object( params[:reimburse] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :reimburse => @object  }  
    else
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      puts msg 

      render :json => msg                         
    end
  end


  def update
    @object = Reimburse.find_by_id params[:id]


    if params[:submit].present?
      params[:reimburse][:submitter] = current_user 
      @object.submit_object( params[:reimburse] )
    elsif params[:confirm].present?
    
        params[:reimburse][:confirmer] = current_user
        @object.confirm_object( params[:reimburse])
    else

      @object.update_object( params[:reimburse])
    end


    if @object.errors.size != 0 
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg
    else
      render :json => { :success => true, 
                        :reimburse => @object  }  
    end
  end

  def destroy
    @object = Reimburse.find_by_id(params[:id])

    if @object.nil?
      render :json => { :success => false , :no_record_found => true }  
      return 
    end
    
    begin
      ActiveRecord::Base.transaction do 
        @object.delete_object 
      end
    rescue ActiveRecord::ActiveRecordError  

    else
    end
    
    

    if not @object.persisted?  
      render :json => { :success => true }  
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
 