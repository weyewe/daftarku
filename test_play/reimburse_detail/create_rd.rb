require 'httparty'
require 'json'
 
BASE_URL = "http://localhost:3000"

source_user = User.first

response = HTTParty.post( "#{BASE_URL}/api2/users/sign_in" ,
  { 
    :body => {
    	:user_login => { :email => source_user.email , :password => "willy1234" }
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

  
    
  end

else
end

reimburse.reimburse_details.each {|x| x.delete_object}



response = HTTParty.post( "#{BASE_URL}/api2/reimburse_details" ,{
    :query => {
      :auth_token => auth_token  
    },
    
    :body => {
      :reimburse_detail => {  
        :reimburse_id => reimburse.id ,
        :title => "This is title",
        :description => "this is the description",
        :transaction_datetime  => DateTime.now ,
        :receipt_url_mini => nil , 
        :receipt_url_original => nil ,
        :amount => BigDecimal("2342")
      }
    }


  })



server_response =  JSON.parse(response.body )


response = HTTParty.post( "#{BASE_URL}/api2/reimburse_details" ,{
    :query => {
      :auth_token => auth_token  
    },
    
    :body => {
      :reimburse_detail => {  
        :reimburse_id =>  nil  ,
        :title => "This is title",
        :description => "this is the description",
        :transaction_datetime  => DateTime.now ,
        :receipt_url_mini => nil , 
        :receipt_url_original => nil ,
        :amount => BigDecimal("100000")
      }
    }


  })



server_response =  JSON.parse(response.body )