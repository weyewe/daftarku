
require 'httparty'
require 'json'

source_user = User.first
target_user = User.last 

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

  end


end

response = HTTParty.put( "#{BASE_URL}/api2/reimburses/#{reimburse.id}" ,{
    :query => {
      :auth_token => auth_token  
    },
    
    :body => {
      :reimburse => {  
          :title => "Bakaboom",
          :description => "This is the description of the reimburse",
          :application_date => DateTime.now  
      }
    }


  })



server_response =  JSON.parse(response.body )
