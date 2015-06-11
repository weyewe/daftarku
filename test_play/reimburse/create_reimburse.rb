require 'httparty'
require 'json'
 
BASE_URL = "http://localhost:3000"

response = HTTParty.post( "#{BASE_URL}/api2/users/sign_in" ,
  { 
    :body => {
    	:user_login => { :email => "target@gmail.com", :password => "willy1234" }
    }
  })

server_response =  JSON.parse(response.body )

auth_token  = server_response["auth_token"]


response = HTTParty.post( "#{BASE_URL}/api2/reimburses" ,{
    :query => {
      :auth_token => auth_token 
    },
    
    :body => {
      :reimburse => {  
         :title => "This is the reimburse title",
        :description => "This is the description of the reimburse",
        :application_date => DateTime.now ,
        :amount => BigDecimal('5050').to_s
      }
    }


  })

server_response =  JSON.parse(response.body )

#### fail case 




response = HTTParty.post( "#{BASE_URL}/api2/reimburses" ,{
    :query => {
      :auth_token => auth_token  
    },
    
    :body => {
      :reimburse => {  
         :title => "",
        :description => "This is the description of the reimburse",
        :application_date => DateTime.now ,
        :amount => "24234"
      }
    }


  })



server_response =  JSON.parse(response.body )
