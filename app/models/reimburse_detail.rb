class ReimburseDetail < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  validates_presence_of :title 
  validates_presence_of :reimburse_id 
  # validates_presence_of :amount
   
  belongs_to :reimburse 
  has_many :comments
  

  # validate :valid_amount 

  def valid_amount 
    return if not amount.present?

    if amount <= BigDecimal("0")
      self.errors.add(:amount, "Tidak boleh 0 atau negative")
      return self 
    end
  end


  def check_valid_reimburse
    if not reimburse_id.present? 
      self.errors.add(:reimburse_id, "Harus ada" ) 
      return self
    end
    
    object = Reimburse.find_by_id reimburse_id
    
    if object.nil?
      self.errors.add(:reimburse_id , "Harus ada")
      return self 
    end
    
    
  end
  
  def self.create_object( params ) 
    
    new_object = self.new 
    new_object.reimburse_id           =   params[:reimburse_id]           
    new_object.title                  =   params[:title] 
    new_object.description            =   params[:description]
    new_object.transaction_datetime   =   params[:transaction_datetime]

    new_object.website_url   =   params[:website_url]
    new_object.thumb_image_url       =   params[:thumb_image_url]
    new_object.medium_image_url   =   params[:medium_image_url] 
    new_object.optimized_image_url   =   params[:optimized_image_url] 

    new_object.amount        = BigDecimal( params[:amount] || '0')
    
    new_object.check_valid_reimburse
      
    if new_object.errors.size != 0 
      return new_object
    else
      if not new_object.reimburse.is_submitted? 
        new_object.save  
      else
        new_object.errors.add(:generic_errors, "Sudah di submit")
        return new_object
      end
    end
    
    return new_object
  end
  
  def update_object( params )          
    if self.reimburse.is_submitted?
      self.errors.add(:generic_errors, "Sudah submit")
      return self 
    end
    
    self.title                  =   params[:title] 
    self.description            =   params[:description]
    self.transaction_datetime   =   params[:transaction_datetime] 

    self.website_url   =   params[:website_url]
    self.thumb_image_url       =   params[:thumb_image_url]
    self.medium_image_url   =   params[:medium_image_url] 
    self.optimized_image_url   =   params[:optimized_image_url] 
    self.amount        = BigDecimal( params[:amount] || '0')
    self.save 
    return self 
  end
  
  
  # by product 
  def mark_as_rejected
    self.is_rejected  = true
    self.save 
    return self 
  end
  
  def delete_object
    if self.reimburse.is_submitted?
      self.errors.add(:generic_errors, "Sudah di kumpulkan")
      return self 
    end
      
    self.destroy 
  end
end
