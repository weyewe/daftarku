class User < ActiveRecord::Base
  # include TheRole::User
  include TheRole::Api::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  attr_accessible :username
   before_save :ensure_authentication_token

  has_many :reimburse_associations
  has_many :reimburses, :through => :reimburse_associations 
  has_many :comments 

  
   def ensure_authentication_token
     if authentication_token.blank?
       self.authentication_token = generate_authentication_token
     end
   end

   # Setup accessible (or protected) attributes for your model
   attr_accessible :email, :password, :password_confirmation, :remember_me, :name , :role_id

   validates_uniqueness_of :email 
   validates_presence_of :email  # , :role_id 

   validate :valid_role

   def valid_role

     return if not role_id.present?

     if role_id == 0
       errors.add(:role_id, "Role harus dipilih")
     end
   end

   def self.create_main_user(params) 
     new_user = User.new( :email => params[:email], 
                             :password => params[:password],
                             :password_confirmation => params[:password_confirmation] ,
                             :name => params[:name])


     admin_role = Role.find_by_name ROLE_NAME[:admin]
     new_user.role_id = admin_role.id 
     new_user.is_main_user = true
 

     new_user.save 

     return new_user 
   end

   def self.active_objects
     self.where(:is_deleted => false).order("id DESC")
   end

   def delete_object 

    
      random_password                    = UUIDTools::UUID.timestamp_create.to_s[0..7]
      self.password = random_password
      self.password_confirmation = random_password 
      self.is_deleted = true 
      self.save 

   end

   
   def self.create_random_object(params ) 
    new_object                        = User.new 
    new_object.name                  = params[:name]
    new_object.email                 = params[:email] 


    if Rails.env.test? or Rails.env.development? 
      password                         = "willy1234" # UUIDTools::UUID.timestamp_create.to_s[0..7]

      new_object.password              = password
      new_object.password_confirmation = password 
    else
      password                         =  UUIDTools::UUID.timestamp_create.to_s[0..7]
      new_object.password              = password
      new_object.password_confirmation = password
    end



    new_object.save




    if new_object.valid? and Rails.env.production? 
      # password => SEnd random password
     # UserMailer.notify_new_user_registration( new_object , password    ).deliver 
    end
    
    return new_object
   end


   def User.create_object(params)
     # only used in seeds.rb => we need to assign pre-determined password


     new_object                        = User.new 
     new_object.name                  = params[:name]
     new_object.email                 = params[:email] 

     if Rails.env.test? 
      password                         = "willy1234" # UUIDTools::UUID.timestamp_create.to_s[0..7]
     
      new_object.password              = password
      new_object.password_confirmation = password 
     else
      new_object.password              = params[:password]
      new_object.password_confirmation = params[:password_confirmation]
     end
     

    
     new_object.save




     if new_object.valid? and Rails.env.production? 
       # UserMailer.notify_new_user_registration( new_object , password    ).deliver 
     end
     return new_object

   end

   def update_object( params )
     # admin_role = Role.find_by_name ROLE_NAME[:admin]

     self.name                  = params[:name]
     self.email                 = params[:email]  
     self.original_avatar_url  = params[:original_avatar_url]
     self.mini_avatar_url = params[:mini_avatar_url]


 
     self.role_id = params[:role_id]
     self.save
     return self
   end



   def update_password(  params) 
     self.password = params[:password]
     self.password_confirmation = params[:password_confirmation]

     self.save 

     return self 

   end

   def reset_password( employee, params ) 
     password                   = UUIDTools::UUID.timestamp_create.to_s[0..7]
     self.password              = password
     self.password_confirmation = password 

     if self.save
       # UserMailer.notify_reset_password( employee, self , password    ).deliver
     end

     return self
   end

   def set_as_main_user 
     admin_role = Role.find_by_name ROLE_NAME[:admin]
     self.role_id = admin_role.id 
     self.is_main_user = true 
     self.save 
   end
  
  def is_associated_with?(reimburse)
    ReimburseAssociation.where(:user_id => self.id, :reimburse_id => reimburse.id ).count != 0 
  end

  

 

   def generate_authentication_token
     loop do
       token = Devise.friendly_token
       break token unless User.where(authentication_token: token).first
     end
   end
end
