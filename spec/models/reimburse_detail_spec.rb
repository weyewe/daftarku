require 'spec_helper'

describe ReimburseDetail do
  before(:each) do 
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
    @admin_1 = User.create_main_user(  :name => "Admin", 
              :email => "admin@gmail.com" ,
              :password => "willy1234", :password_confirmation => "willy1234") 
    @admin_1.set_as_main_user
    
    @admin_2 = User.create_main_user(  :name => "Admin2", 
              :email => "admin2@gmail.com" ,
              :password => "willy1234", :password_confirmation => "willy1234") 
    @admin_2.set_as_main_user
    
    @admin_1_email = "admin@gmail.com"
    @admin_2_email = "admin2@gmail.com"
    @destination_email = "w.yunnal@gmail.com"
    
    @reimburse = Reimburse.create_object(
        :user_id => @admin_1.id, 
        :title => "This is the reimburse title",
        :description => "This is the description of the reimburse",
        :application_date => DateTime.now 
        ) 
    @reimburse_detail_1 = ReimburseDetail.create_object(
        :reimburse_id => @reimburse.id ,
        :title => "This is title",
        :description => "this is the description",
        :transaction_datetime  => DateTime.now ,
        :receipt_url_mini => nil , 
        :receipt_url_original => nil 
        )

     @reimburse_detail_2 = ReimburseDetail.create_object(
          :reimburse_id => @reimburse.id ,
          :title => "This is title haaha",
          :description => "this is the description",
          :transaction_datetime  => DateTime.now ,
          :receipt_url_mini => nil , 
          :receipt_url_original => nil 
          )

    @reimburse_detail_3 = ReimburseDetail.create_object(
        :reimburse_id => @reimburse.id ,
        :title => "This is title 3",
        :description => "this is the description",
        :transaction_datetime  => DateTime.now ,
        :receipt_url_mini => nil , 
        :receipt_url_original => nil 
        )
    @reimburse.submit_object( :submitted_at => DateTime.now , :destination_email => @destination_email ) 
  end
  
  it "should produce no error" do
    @reimburse.errors.size.should ==0 
    @reimburse_detail_1.errors.size.should == 0 
    @reimburse_detail_2.errors.size.should == 0 
    @reimburse_detail_3.errors.size.should == 0 
  end
  
  it "should submit the reimburse" do
    puts "Total error : #{@reimburse.errors.size}"
    @reimburse.errors.messages.each {|x| puts "The error #{x}"}
    @reimburse.reload 
    @reimburse.is_submitted.should be_truthy
  end
  
  it "should not be allowed to create reimburse detail" do 
    @reimburse_detail_4 = ReimburseDetail.create_object(
        :reimburse_id => @reimburse.id ,
        :title => "This is title 4",
        :description => "this is the description",
        :transaction_datetime  => DateTime.now ,
        :receipt_url_mini => nil , 
        :receipt_url_original => nil 
        )
    
    @reimburse_detail_4.errors.size.should_not == 0
  end
  
end
