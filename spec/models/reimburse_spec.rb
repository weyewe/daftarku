require 'spec_helper'

describe Reimburse do
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
    @admin_1 = User.create_main_user(  :name => "Admin", :email => "admin@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234") 
    @admin_1.set_as_main_user
    
    @admin_2 = User.create_main_user(  :name => "Admin2", :email => "admin2@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234") 
    @admin_2.set_as_main_user
    
    @admin_1_email = "admin@gmail.com"
    @admin_2_email = "admin2@gmail.com"
    @destination_email = "w.yunnal@gmail.com"
  end
  
  it "should be allowed to create reimburse" do
    reimburse = Reimburse.create_object(
      :user_id => @admin_1.id, 
      :title => "This is the reimburse title",
      :description => "This is the description of the reimburse",
      :application_date => DateTime.now 
      )
    
    reimburse.errors.messages.each {|x| puts "===> #{x}"} 
    reimburse.should be_valid 
  end
  
  it "should not be allowed to create reimburse if there is no title" do
    reimburse = Reimburse.create_object(
      :user_id => @admin_1.id, 
      :title => "",
      :description => "This is the description of the reimburse",
      :application_date => DateTime.now)
    
    reimburse.should_not be_valid 
    
    reimburse = Reimburse.create_object(
      :user_id => @admin_1.id, 
      :title => nil ,
      :description => "This is the description of the reimburse",
      :application_date => DateTime.now 
      )
    reimburse.should_not be_valid 
  end
  
  
  
  context "created reimburse" do
    before(:each) do
      @reimburse = Reimburse.create_object(
        :user_id => @admin_1.id, 
        :title => "This is the reimburse title",
        :description => "This is the description of the reimburse",
        :application_date => DateTime.now 
        )
      @reimburse.should be_valid
    end
    
    it "should create 1 reimburse_association" do
      ReimburseAssociation.count.should == 1 
      ReimburseAssociation.where(
        :user_id => @admin_1.id,
        :reimburse_id => @reimburse.id,
        :association_status => ASSOCIATION_STATUS[:source]
        ).count.should == 1 
    end
    
    it "should create valid reimburse " do 
      @reimburse.should be_valid
    end
    
    it "should not allowed to submit reimburse" do
      @reimburse.submit_object( :submitted_at => DateTime.now , :destination_email => @destination_email )
    end
    
    it "should be allowed to update reimburse" do
      @reimburse.update_object(
        :user_id => @admin_1.id,
        :title => "This is amazing title"
        )
      @reimburse.errors.size.should == 0 
    end
    
    it "should ignore user_id changes on update" do
      @reimburse.update_object(
        :user_id => @admin_2.id,
        :title => "This is amazing title"
        )
      @reimburse.errors.size.should == 0 
      
      @reimburse.user_id.should == @admin_1.id 
    end
    
    it "should not allow reimburse detail creation without reimburse_id" do
      reimburse_detail_1 = ReimburseDetail.create_object(
          :reimburse_id => nil, 
          :title => "This is title",
          :description => "this is the description",
          :transaction_datetime  => DateTime.now ,
          :receipt_url_mini => nil , 
          :receipt_url_original => nil 
          )
      reimburse_detail_1.errors.size.should_not == 0 #should_not be_valid 
      
      reimburse_detail_1 = ReimburseDetail.create_object(
          :reimburse_id => 0, 
          :title => "This is title",
          :description => "this is the description",
          :transaction_datetime  => DateTime.now ,
          :receipt_url_mini => nil , 
          :receipt_url_original => nil 
          )
      reimburse_detail_1.errors.size.should_not == 0 # should_not be_valid 
      
    end
    

    it "should not be allowed to subit reimburse withhout detail" do
      @reimburse.submit_object( :submitted_at => DateTime.now , :destination_email => @destination_email )
    
      @reimburse.errors.size.should_not == 0 
    end

    context "create reimburse detail" do
      before(:each) do
        @reimburse_detail_1 = ReimburseDetail.create_object(
          :reimburse_id => @reimburse.id ,
          :title => "This is title",
          :description => "this is the description",
          :transaction_datetime  => DateTime.now ,
          :receipt_url_mini => nil , 
          :receipt_url_original => nil 
          )
      end
      
      it "should be allowed to create reimburse detail" do
        @reimburse_detail_1.should be_valid 
      end

      it 

      it "should not be allowed to be submitted by non source reimburse" do
        @reimburse.should be_valid 
        reimburse_user_id = @reimburse.user_id

        non_source_user = User.where{id.not_eq  reimburse_user_id}.first 
        @reimburse.submit_object( :submitted_at => DateTime.now , :destination_email => @destination_email ,
                :submitter => non_source_user )

        @reimburse.errors.size.should_not == 0 

      end
      
      context "submit the reimburse" do
        before(:each) do
          @reimburse.submit_object( :submitted_at => DateTime.now , :destination_email => @destination_email ,
                :submitter => @reimburse.user )
        end
        
        it "should have no error" do
          @reimburse.errors.size.should == 0
        end
        
        it "should confirm the submission" do
          @reimburse.is_submitted.should be_truthy 
        end
        
        it "should create another user with email == @destination_email" do
          User.where( :email => @destination_email ).count.should == 1
        end
        
        it "should create 2 reimburse_associations" do 
          ReimburseAssociation.where(:reimburse_id => @reimburse.id).count.should == 2 
        end
        
        
        
        context "confirm reimburse submission" do
          before(:each) do
            
            @reimburse_detail_2 = ReimburseDetail.create_object(
              :reimburse_id => @reimburse.id ,
              :title => "This is title",
              :description => "this is the description",
              :transaction_datetime  => DateTime.now ,
              :receipt_url_mini => nil , 
              :receipt_url_original => nil 
              )
            
            @reimburse_detail_3 = ReimburseDetail.create_object(
              :reimburse_id => @reimburse.id ,
              :title => "This is title",
              :description => "this is the description",
              :transaction_datetime  => DateTime.now ,
              :receipt_url_mini => nil , 
              :receipt_url_original => nil 
              )
            @reimburse.confirm_object( 
              :rejected_id_list => [@reimburse_detail_1.id ],
              :confirmer => @reimburse.target_reimburse_user
              )
          end
          
          it "should confirm the reimburse" do
            @reimburse.is_confirmed.should be_truthy 
            @reimburse_detail_1.is_rejected.should be_falsy  
          end
        end
        
      end


    end
  



  end
  
end
