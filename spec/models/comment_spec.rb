require 'spec_helper'

describe Comment do
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
  end
  
  it "should not be allowed to create comment on the unsubmitted reimburse" do
    comment = Comment.create_object( 
      :user_id => @admin_1.id ,
      :content => "Ths is fucking awesome content",
      :reimburse_detail_id => @reimburse_detail_3.id,
      :post_datetime => DateTime.now 
      )
    
    comment.errors.size.should_not == 0   
  end
  
  context "submit the reimburse" do
    before(:each) do
      @reimburse.submit_object( :submitted_at => DateTime.now , :destination_email => @destination_email ) 
    end
    
    it "should be allowed to create comment on the submitted reimburse" do
      comment = Comment.create_object( 
        :user_id => @admin_1.id ,
        :content => "Ths is fucking awesome content",
        :reimburse_detail_id => @reimburse_detail_3.id,
        :post_datetime => DateTime.now 
      ) 
      comment.errors.size.should == 0  
      comment.persisted?.should be_truthy
    end
    
    it "should be allowed to create comment on the submitted reimburs: by destination user" do
      destination_user = User.find_by_email @destination_email
      comment = Comment.create_object( 
        :user_id => destination_user.id ,
        :content => "Ths is fucking awesome content",
        :reimburse_detail_id => @reimburse_detail_3.id,
        :post_datetime => DateTime.now 
      ) 
      comment.errors.size.should == 0  
      comment.persisted?.should be_truthy
    end
    
    it "should not be allowed to create comment by user with no association" do
      destination_user = User.find_by_email @destination_email
      comment = Comment.create_object( 
        :user_id => @admin_2.id ,
        :content => "Ths is fucking awesome content",
        :reimburse_detail_id => @reimburse_detail_3.id,
        :post_datetime => DateTime.now 
      ) 
      
      comment.errors.size.should_not == 0  
      comment.persisted?.should be_falsy
    end
  end
end
