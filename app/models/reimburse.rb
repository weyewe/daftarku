class Reimburse < ActiveRecord::Base
  validates_presence_of :title 
  validates_presence_of :user_id
  validate :user_must_be_valid 
   
  has_many :reimburse_details 
  
  has_many :reimburse_associations
  has_many :users, :through => :reimburse_associations
  

  def first_reimburse_detail
    self.reimburse_details.first 
  end

  
  # def first_receipt_mini_url
  #   first_reimburse = self.reimburse_details.first
  #   if not first_reimburse.nil?
  #     return first_reimburse.receipt_mini_url
  #   else
  #     return nil
  #   end
  # end



  def user
    User.find_by_id self.user_id 
  end
  
  def target_reimburse_user
    User.find_by_email( self.destination_email ) 
  end
  
  def user_must_be_valid
    return if not user_id.present? 
    
    creator = User.find_by_id user_id 
    if creator.nil?
      self.errors.add(:user_id , "Harus ada user")
      return self 
    end
  end
  
  def self.create_object( params ) 
    new_object = self.new 
    new_object.user_id             = params[:user_id]
    new_object.title               =  params[:title]
    new_object.description         =   params[:description]
    new_object.application_date    = params[:application_date]

    new_object.thumb_image_url    = params[:thumb_image_url]
    new_object.medium_image_url    = params[:medium_image_url]
    new_object.optimized_image_url    = params[:optimized_image_url]
    if new_object.save 
      ReimburseAssociation.create_object(
        :reimburse_id => new_object.id ,
        :user_id => new_object.user_id,
        :association_status => ASSOCIATION_STATUS[:source]
        )
    end
    
    return new_object 
  end
  
  
  def update_object( params ) 
    if self.is_submitted? or self.is_confirmed
      self.errors.add(:generic_errors, "Sudah konfirmasi atau disubmit")
      return self 
    end
    
    self.title               =  params[:title]
    self.description         =   params[:description]
    self.application_date    = params[:application_date] 
    self.thumb_image_url    = params[:thumb_image_url]
    self.medium_image_url    = params[:medium_image_url]
    self.optimized_image_url    = params[:optimized_image_url]
    self.save 
    
    return self 
  end

  def can_be_submitted_by?( submitter)  
    total_source_association =  ReimburseAssociation.where(
        :user_id => submitter.id, 
        :reimburse_id => self.id ,
        :association_status => ASSOCIATION_STATUS[:source]
      ).count  != 0 
  end
  
  def submit_object( params ) 
    
    if self.is_submitted?
      self.errors.add(:generic_errors, "Sudah di submit")
      return self 
    end

    if self.reimburse_details.count == 0 
      self.errors.add(:generic_errors, "harus ada reimburse detail")
      return self 
    end
    
    if not params[:destination_email].present?
      self.errors.add(:destination_email, "Tidak valid")
      return self 
    end 
    
    if not EmailValidator.valid?( params[:destination_email] )  
      self.errors.add(:destination_email, "Tidak Valid")
      return self 
    end
    
    submitter =  params[:submitter]

    if submitter.nil?
      self.errors.add(:generic_errors, "Tidak ada submitter")
      return self 
    end

    if not self.can_be_submitted_by?( submitter  )
      self.errors.add(:generic_errors, "Submitter invalid")
      return self 
    end

   
    
    self.is_submitted = true 
    self.submitted_at = params[:submitted_at ]
    self.destination_email = params[:destination_email]
    if self.save 
      destination_user = User.find_by_email( self.destination_email ) 
      if destination_user.nil?
        destination_user = User.create_random_object(
          :name =>  "New User",
          :role_id => nil ,
          :email => self.destination_email  
        )
      end
      
      ReimburseAssociation.create_object(
          :user_id => destination_user.id, 
          :reimburse_id => self.id ,
          :association_status => ASSOCIATION_STATUS[:target]
          )
    end
  end

  def undo_submit
    ReimburseAssociation.where(
        :association_status => ASSOCIATION_STATUS[:target],
        :reimburse_id => self.id
      ).each {|x| x.destroy }

    self.is_submitted = false
    self.destination_email = nil
    self.submitted_at = nil
    self.save
  end

   

  def can_be_confirmed_by?( confirmer)  
    ReimburseAssociation.where(
        :user_id => confirmer.id, 
        :reimburse_id => self.id ,
        :association_status => ASSOCIATION_STATUS[:target]
      ).count  != 0 
  end


  
  def confirm_object( params ) 
    if not self.is_submitted?
      self.errors.add(:generic_errors, "Belum di submit")
      return self
    end
    
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah dikonfirmasi")
      return self 
    end

    confirmer = params[:confirmer]

    if confirmer.nil?
      self.errors.add(:generic_errors, "Tidak ada confirmer")
      return self 
    end

    if not self.can_be_confirmed_by?( confirmer  )
      self.errors.add(:generic_errors, "Confirmer tidak valid")
      return self 
    end


    
    self.is_confirmed = true 
    self.confirmed_at = DateTime.now 
    
    if self.save and not params[:rejected_id_list].nil?
      params[:rejected_id_list].each do |rejected_id|
        ReimburseDetail.where(
          :reimburse_id => self.id,
          :id => rejected_id
          ).each {|r_d| r_d.mark_as_rejected }
      end
    end
  end

  def undo_confirm
    self.reimburse_details.each do |x|
      x.is_rejected  = true 
      x.save 
    end
    self.is_confirmed = false
    self.confirmed_at = nil 
    self.save 
    
  end
   
  def delete_object 
    if is_submitted?
      self.errors.add(:generic_errors, "Sudah di submit")
      return self
    end
    
    if is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    
    self.reimburse_details.each do |r_d|
      r_d.delete_object 
    end
    
    self.reimburse_associations.each do |r_a|
      r_a.delete_object 
    end
    
    self.destroy 
  end

  def is_associated_with?( user  )
    ReimburseAssociation.where(
        :user_id => user.id, 
        :reimburse_id => self.id 
      ).count  != 0 
  end

  def total_approved
    self.reimburse_details.where(:is_rejected => false ).sum("amount")
  end
end
