class Comment < ActiveRecord::Base
  
  validates_presence_of :content, :user_id, :reimburse_detail_id  
  belongs_to :reimburse_detail
  belongs_to :user
  
  def valid_object
    return if not reimburse_detail_id.present?
    return if not user_id.present?
    reimburse_detail_object = ReimburseDetail.find_by_id reimburse_detail_id
    
    if reimburse_detail_object.nil?
      self.errors.add(:reimburse_detail_id , "Harus ada")
      return self 
    end
    
    user_object = User.find_by_id user_id
    
    if user_object.nil?
      self.errors.add(:user_id , "Harus ada")
      return self 
    end
    
    if ReimburseAssociation.where(
      :user_id => user_id,
      :reimburse_id => reimburse_detail_object.reimburse_id 
      ).count ==0 
      self.errors.add(:generic_errors, "User tidak terdaftar")
      return self 
    end
    
    
    
  end
  
 
  
  
  def self.create_object( params ) 
    new_object = self.new
    new_object.reimburse_detail_id = params[:reimburse_detail_id]
    new_object.content = params[:content]
    new_object.user_id = params[:user_id]
    new_object.post_datetime = params[:post_datetime]
    
    
    new_object.valid_object
    
    if new_object.errors.size != 0 
      return new_object
    else
      if not new_object.reimburse_detail.reimburse.is_submitted?
        new_object.errors.add(:generic_errors, "Reimburse belum di submit")
        return new_object 
      else
        new_object.save 
      end
    end
    
    
    
    return new_object 
    
  end
   
end
