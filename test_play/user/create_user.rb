require 'httparty'
require 'json'
 
BASE_URL = "http://localhost:3000"




response = HTTParty.post( "#{BASE_URL}/api2/app_users" ,{
    :body => {
      :user => {  
         :name => "App User",
        :email => "app_user@gmail.com",
        :password =>  "app_user_awesome",
        :password_confirmation =>  "app_user_awesome",
      }
    }


  })

server_response =  JSON.parse(response.body )

#### fail case 


response = HTTParty.post( "#{BASE_URL}/api2/app_users" ,{
    :body => {
      :user => {  
         :name => "App User",
        :email => "app_user@gmail.com",
        :password =>  "app_user_awesomeefa",
        :password_confirmation =>  "app_user_awesome",
      }
    }


  })

server_response =  JSON.parse(response.body )
  })



server_response =  JSON.parse(response.body )
