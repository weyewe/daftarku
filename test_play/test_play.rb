require 'httparty'
require 'json'
 
# BASE_URL = "http://localhost:3000"
BASE_URL = "https://repay-staging.herokuapp.com"

response = HTTParty.post( "#{BASE_URL}/api2/users/sign_in" ,
  { 
    :body => {
    	:user_login => { :email => "target@gmail.com", :password => "willy1234" }
    }
  })

server_response =  JSON.parse(response.body )

auth_token  = server_response["auth_token"]

# try to get the shite

response = HTTParty.get( "#{BASE_URL}/api2/reimburse_associations" ,
  :query => {
  	:auth_token => auth_token
  })

server_response =  JSON.parse(response.body )


# gonna test reimburse creation 
source_user = User.first
target_user = User.last 

=begin 
reimburse = Reimburse.create_object(
          :user_id => source_user.id, 
          :title => "Title #{source_user.email}",
          :description => "This is the description of the reimburse",
          :application_date => DateTime.now 
          )

(1.upto 3).each do |x| 
	reimburse_detail = ReimburseDetail.create_object(
	      :reimburse_id => reimburse.id ,
	      :title => "Title #{x} ",
	      :description => "this is the description",
	      :transaction_datetime  => DateTime.now ,
	      :receipt_url_mini => nil , 
	      :receipt_url_original => nil 
	      )
end

reimburse.submit_object(
  :submitted_at => DateTime.now , 
  :destination_email => target_user.email,
  :submitter => source_user  )

reimburse.undo_submit
=end


ReimburseAssociation.where(
    :user_id => source_user.id, 
    :reimburse_id => reimburse.id ,
    :association_status => ASSOCIATION_STATUS[:source]
  ).count != 0 