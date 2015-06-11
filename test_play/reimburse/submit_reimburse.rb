require 'httparty'
require 'json'

source_user = User.first
target_user = User.last 

BASE_URL = 'http://localhost:3000'
response = HTTParty.post( "#{BASE_URL}/api2/users/sign_in" ,
  { 
    :body => {
      :user_login => { :email => source_user.email, :password => "willy1234" }
    }
  })

server_response =  JSON.parse(response.body )

auth_token  = server_response["auth_token"]


reimburse = Reimburse.where(:is_submitted => false , :is_confirmed => false, 
        :user_id => source_user.id ).first 



if reimburse.nil? 
  submitted_not_confirmed_reimburse = Reimburse.where(:is_submitted => true , 
    :is_confirmed => false, 
        :user_id => source_user.id ).first

  if not submitted_not_confirmed_reimburse.nil? 
    submitted_not_confirmed_reimburse.undo_submit
    reimburse  = submitted_not_confirmed_reimburse
  else
    reimburse = Reimburse.create_object(
          :user_id => source_user.id, 
          :title => "Title #{source_user.email}",
          :description => "This is the description of the reimburse",
          :application_date => DateTime.now 
          )

    reimburse_detail_1 = ReimburseDetail.create_object(
          :reimburse_id => reimburse.id ,
          :title => "This is title",
          :description => "this is the description",
          :transaction_datetime  => DateTime.now ,
          :receipt_url_mini => nil , 
          :receipt_url_original => nil ,
          :amount => BigDecimal("200")
          )

    
  end

else
  if reimburse.reimburse_details.count == 0 
    reimburse_detail_1 = ReimburseDetail.create_object(
          :reimburse_id => reimburse.id ,
          :title => "This is title",
          :description => "this is the description",
          :transaction_datetime  => DateTime.now ,
          :receipt_url_mini => nil , 
          :receipt_url_original => nil ,
          :amount => BigDecimal("324000")
          )
  end
end

response = HTTParty.put( "#{BASE_URL}/api2/reimburses/#{reimburse.id}" ,{
    :query => {
      :auth_token => auth_token ,
      :submit => true 
    },
    
    :body => {
      :reimburse => {  
          :submitted_at => DateTime.now , 
          :destination_email => target_user.email  
      }
    }


  })



server_response =  JSON.parse(response.body )
