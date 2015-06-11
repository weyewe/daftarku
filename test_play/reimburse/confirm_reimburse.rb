require 'httparty'
require 'json'

source_user = User.first
target_user = User.last 

BASE_URL = "http://localhost:3000"

response = HTTParty.post( "#{BASE_URL}/api2/users/sign_in" ,
  { 
    :body => {
      :user_login => { :email => target_user.email, :password => "willy1234" }
    }
  })

server_response =  JSON.parse(response.body )

auth_token  = server_response["auth_token"]




reimburse  = Reimburse.joins(:reimburse_associations).where{
  ( reimburse_associations.user_id.eq target_user.id ) & 
  ( reimburse_associations.association_status.eq ASSOCIATION_STATUS[:target]) & 
  ( is_submitted.eq true ) & 
  ( is_confirmed.eq false  ) 

}.first 



@reimburse_detail_1 = nil
@reimburse_detail_2 = nil 
if reimburse.nil? 
  confirmed_reimburse = Reimburse.joins(:reimburse_associations).where{
    ( reimburse_associations.user_id.eq target_user.id ) & 
    ( reimburse_associations.association_status.eq ASSOCIATION_STATUS[:target]) & 
    ( is_submitted.eq true ) & 
    ( is_confirmed.eq true  ) 
  }.first 

  if not confirmed_reimburse.nil? 
    confirmed_reimburse.undo_confirm
    reimburse  = confirmed_reimburse
    @reimburse_detail_1 = reimburse.reimburse_details.first 
  else
    reimburse = Reimburse.create_object(
          :user_id => source_user.id, 
          :title => "Title #{source_user.email}",
          :description => "This is the description of the reimburse",
          :application_date => DateTime.now 
          )

    @reimburse_detail_1 = ReimburseDetail.create_object(
          :reimburse_id => reimburse.id ,
          :title => "This is title",
          :description => "this is the description",
          :transaction_datetime  => DateTime.now ,
          :receipt_url_mini => nil , 
          :receipt_url_original => nil ,
          :amount => BigDecimal('234')
          )

    @reimburse_detail_2 = ReimburseDetail.create_object(
          :reimburse_id => reimburse.id ,
          :title => "This is title 2",
          :description => "this is the description",
          :transaction_datetime  => DateTime.now ,
          :receipt_url_mini => nil , 
          :receipt_url_original => nil ,
          :amount => BigDecimal('100000')
          )

 

    reimburse.submit_object( 
      :submitted_at => DateTime.now , 
      :destination_email => target_user.email )
  end
else
  @reimburse_detail_1 = reimburse.reimburse_details.first 

end


response = HTTParty.put( "#{BASE_URL}/api2/reimburses/#{reimburse.id}" ,{
    :query => {
      :auth_token => auth_token ,
      :confirm => true 
    },
    
    :body => {
      :reimburse => {  
          :confirmed_at => DateTime.now , 
          :rejected_id_list => [@reimburse_detail_1.id ]  # [1,2,3,4,5]
      }
    }


  })



server_response =  JSON.parse(response.body )


