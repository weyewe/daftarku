require 'httparty'
require 'json'
 
BASE_URL = "https://repay-staging.herokuapp.com"  # "http://localhost:3000" #  



response = HTTParty.post( "#{BASE_URL}/api2/users/sign_in" ,
  { 
    :body => {
    	:user_login => { :email => "admin@gmail.com", :password => "willy1234" }
    }
  })

server_response =  JSON.parse(response.body )

auth_token  = server_response["auth_token"]

# try to get the shite

response = HTTParty.get( "#{BASE_URL}/api2/reimburses" ,
  :query => {
  	:auth_token => auth_token 
  })

server_response =  JSON.parse(response.body )