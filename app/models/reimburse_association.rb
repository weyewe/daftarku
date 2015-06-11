class ReimburseAssociation < ActiveRecord::Base
  validates_presence_of :user_id, :association_status, :reimburse_id 
  
  validate :valid_user
  validate :valid_association_status
  validate :valid_reimburse 

  belongs_to :user
  belongs_to :reimburse
  
  def valid_user
    return if not user_id.present? 
    
    object = User.find_by_id user_id
    if object.nil?
      self.errors.add(:user_id , "User harus ada" ) 
      return self 
    end
  end
  
  def valid_association_status
    return if not association_status.present? 
    
    if not [
      ASSOCIATION_STATUS[:source],
      ASSOCIATION_STATUS[:target] 
      ].include?( association_status)
      self.errors.add(:association_status, "Harus ada ")
      return self 
    end
  end
  
  def valid_reimburse
    return if not reimburse_id.present? 
    object = Reimburse.find_by_id reimburse_id 
    
    if object.nil?
      self.errors.add(:reimburse_id, "Harus ada")
      return self 
    end
  end
  
  
  def self.create_object( params ) 
    new_object = self.new
    
    new_object.user_id = params[:user_id]
    new_object.association_status = params[:association_status]
    new_object.reimburse_id = params[:reimburse_id ]
    
    new_object.save 
    
  end
  
  def delete_object
    if  self.reimburse.is_submitted? 
      self.errors.add(:generic_errors, "Sudah di submit")
      return self 
    end
    
    self.destroy 
    
  end
end
