require 'httparty'
require 'json'
 
BASE_URL = "https://repay-staging.herokuapp.com"

# BASE_URL="http://reimburseapp.com"

response = HTTParty.post( "#{BASE_URL}/api2/users/sign_in" ,
  { 
    :body => {
    	:user_login => { :email => "target@gmail.com", :password => "willy1234" }
    }
  })

server_response =  JSON.parse(response.body )

auth_token  = server_response["auth_token"]