require 'httparty'
require 'json'
 
BASE_URL = "http://localhost:3000"
BASE_URL = "https://repay-staging.herokuapp.com"

source_user = User.first

response = HTTParty.post( "#{BASE_URL}/api2/users/sign_in" ,
  { 
    :body => {
    	:user_login => { :email =>  "target@gmail.com" , :password => "willy1234" }
    }
  })

server_response =  JSON.parse(response.body )

auth_token  = server_response["auth_token"]


reimburse_detail = ReimburseDetail.joins(:reimburse ).where{
  (reimburse.is_submitted.eq false ) & 
  ( reimburse.user_id.eq source_user.id )
}.first 

if reimburse_detail.nil?
  reimburse = Reimburse.create_object(
          :user_id => source_user.id, 
          :title => "Title #{source_user.email}",
          :description => "This is the description of the reimburse",
          :application_date => DateTime.now 
          )

  reimburse_detail = ReimburseDetail.create_object(
          :reimburse_id => reimburse.id ,
          :title => "This is title",
          :description => "this is the description",
          :transaction_datetime  => DateTime.now ,
          :receipt_url_mini => nil , 
          :receipt_url_original => nil,
          :amount => BigDecimal("500") 
          )
end
 


reimburse = reimburse_detail.reimburse 


response = HTTParty.get( "#{BASE_URL}/api2/reimburse_details" ,{
    :query => {
      :auth_token => auth_token  ,
      :reimburse_id => reimburse.id
    }
    });

server_response =  JSON.parse(response.body )