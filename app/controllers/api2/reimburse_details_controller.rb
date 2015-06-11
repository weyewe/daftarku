class Api2::ReimburseDetailsController < Api2::BaseMobileApiController
  respond_to :json
  # when the source user click the reimburse, it will be shown with reimburse list
  # if they click the record in this reimburse list, form will be shown. They can edit 
  def index
    @reimburse = Reimburse.find_by_id params[:reimburse_id]
    @objects = []
    if @reimburse and current_user.is_associated_with?( @reimburse )
      @objects = ReimburseDetail.where(:reimburse_id => @reimburse.id ).order("id DESC")
    end
  end
  
  
  
  #   when the user click the reimburse detail from the homepage  
  # => will go to the reimburse_detail#show page 
  def show
    @reimburse_detail = ReimburseDetail.find_by_id params[:id]
    @objects = []  
    
    if @reimburse_detail and current_user.is_associated_with?( @reimburse_detail.reimburse) 
      @objects = Comment.joins(:user).
                where(:reimburse_detail_id => @reimburse_detail.id ).
                order("id ASC")
    end
    
    
  end

  def create

    @reimburse  = Reimburse.find_by_id( params[:reimburse_detail][:reimburse_id])
    if @reimburse.nil? or @reimburse.user_id != current_user.id 
      render :json => { :success => false , :no_record_found => true }  
      return 
    end


    @object = ReimburseDetail.create_object( params[:reimburse_detail] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :reimburse_detail => @object  }  
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
    @object = ReimburseDetail.find_by_id params[:id]

    if @object.nil? 
      render :json => { :success => false , :no_record_found => true }  
      return 
    end

    @parent = @object.reimburse 

    if @parent.nil? or @parent.user_id != current_user.id 
      render :json => { :success => false , :no_record_found => true }  
      return 
    end


    @object.update_object( params[:reimburse_detail])


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
                        :reimburse_detail => @object  }  
    end
  end


  def destroy
    @object = ReimburseDetail.find_by_id(params[:id])

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
=begin
user = User.find_by_email "willy@gmail.com"
reimburse_id_list = []
Reimburse.where(:user_id => user.id ).each {|x | reimburse_id_list << x.id }

reimburse_detail_array = [] 
ReimburseDetail.where(:reimburse_id => reimburse_id_list).each {|x| reimburse_detail_array << x.receipt_mini_url} 


=end