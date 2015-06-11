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


response = HTTParty.put( "#{BASE_URL}/api2/update_password" ,{
	:query => {
      :auth_token => auth_token  
    } , 
    :body => {
      :user => {  
         :current_password => "willy1234",
        :password => "new_password",
        :password_confirmation =>  "new_password"
      }
    }


 })

server_response =  JSON.parse(response.body )

auth_token = server_response["auth_token"]



response = HTTParty.put( "#{BASE_URL}/api2/update_password" ,{
  :query => {
      :auth_token => auth_token  
    } , 
    :body => {
      :user => {  
         :current_password => "new_password",
        :password => "willy1234",
        :password_confirmation =>  "willy1234"
      }
    }


 })

server_response =  JSON.parse(response.body )