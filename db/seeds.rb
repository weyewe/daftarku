role = {
  'system' => {
    'administrator' => true
  }
}

admin_role = Role.create!(
  :name        => ROLE_NAME[:admin],
  :title       => 'Administrator',
  :description => 'Role for administrator',
  :the_role    => role.to_json
)

# admin_role = TheRole.create_admin!

# update admin_role
# https://github.com/TheRole/docs/blob/master/MigrationsFromV2.md
# change role.rb 
#  admin_role.create_rule(:system, :administrator)
      # admin_role.rule_on(:system, :administrator)
# 

role = {
  :passwords => {
    :update => true 
  },
  :works => {
    :index => true, 
    :create => true,
    :update => true,
    :destroy => true,
    :work_reports => true ,
    :project_reports => true ,
    :category_reports => true 
  },
  :projects => {
    :search => true 
  },
  :categories => {
    :search => true 
  }
}

data_entry_role = Role.create!(
  :name        => ROLE_NAME[:data_entry],
  :title       => 'Data Entry',
  :description => 'Role for data_entry',
  :the_role    => role.to_json
)



# if Rails.env.development?

admin_1 = User.create_main_user(  :name => "Admin",
  :email => "admin@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234") 
admin_1.set_as_main_user


admin_2 = User.create_main_user(  :name => "Admin2",
  :email => "admin2@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234") 
admin_2.set_as_main_user

admin_3 = User.create_main_user(  :name => "Admin4",
  :email => "admin4@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234") 
admin_3.set_as_main_user
  
 

user_array  = []
User.all.each {|x| user_array << x }
total_user = user_array.length 

reimburse_array = [] 
(1.upto 5).each do |x|
  selected_user = rand(0..(total_user-1))
  reimburse = Reimburse.create_object(
          # :user_id => user_array[selected_user].id, 
          :user_id => admin_1.id, 
          
          :title => "Title #{x}",
          :description => "This is the description of the reimburse",
          :application_date => DateTime.now 
          )
  
  reimburse_array << reimburse
end

counter = 0 
reimburse_array.each do |reimburse|
  counter  = counter +  1 
  (1.upto 3).each do |x| 
    reimburse_detail = ReimburseDetail.create_object(
          :reimburse_id => reimburse.id ,
          :title => "Title #{counter*x} ",
          :description => "this is the description",
          :transaction_datetime  => DateTime.now ,
          :receipt_url_mini => nil , 
          :receipt_url_original => nil ,
          :amount => counter*x*BigDecimal('500')
          )
    puts reimburse_detail.valid? 
  end
end

target_user_email = "target@gmail.com"
# submit
submitted_reimburse = reimburse_array.last 
submitted_reimburse.submit_object(
  :submitted_at => DateTime.now , 
  :destination_email => target_user_email,
  :submitter => submitted_reimburse.user  )

# create comment on the submitted reimburse
sender = submitted_reimburse.user 
receiver  = submitted_reimburse.target_reimburse_user
puts "the sender" 
puts sender
puts "the receiver"
puts receiver
comment_array = [sender, receiver ]
submitted_reimburse.reimburse_details.each do |reimburse_detail| 
  
  (1.upto 5).each do |counter|
    selected_index = rand(0..(comment_array.length - 1 ) ) 
    selected_commenter = comment_array[selected_index]
    Comment.create_object( 
          :user_id => selected_commenter.id ,
          :content => "#{selected_commenter.name} is saying something #{counter}",
          :reimburse_detail_id => reimburse_detail.id,
          :post_datetime => DateTime.now 
        ) 
  end
  
end

# confirm 
confirmed_reimburse = reimburse_array.first 
counter = 1 
confirmed_reimburse_detail_id_list = [] 
confirmed_reimburse.reimburse_details.each do |x|
  confirmed_reimburse_detail_id_list << x.id 
end

confirmed_reimburse.submit_object(
  :submitted_at => DateTime.now , 
  :destination_email => target_user_email ,
  :submitter => confirmed_reimburse.user )


confirmed_reimburse.confirm_object( 
              :rejected_id_list => [
                  confirmed_reimburse_detail_id_list.first,
                  confirmed_reimburse_detail_id_list.last
                ],
              :confirmer => User.find_by_email( target_user_email ) 
              )



  
target = User.find_by_email "target@gmail.com"
target.password  = "willy1234"
target.password_confirmation  = "willy1234"
target.save
