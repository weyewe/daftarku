class Api2::ReimburseAssociationsController < Api2::BaseMobileApiController
   respond_to :json
  # this action is special => anyone with association is allowed to view
  def index
 
    current_user_id = current_user.id 

    puts "the current_user email : #{current_user.email}"

    @objects  = ReimburseAssociation.includes(:user , :reimburse => [:reimburse_details]).where{
      ( user_id.eq current_user_id ) & 
      ( association_status.not_eq ASSOCIATION_STATUS[:source])
    } 

    puts "====> TOtal object count : #{@objects.count}"

  end

 

end
 
=begin
	
target = User.find_by_email "target@gmail.com"
target_id  = target.id 
ReimburseAssociation.where{
      ( user_id.eq target_id ) & 
      ( association_status.not_eq ASSOCIATION_STATUS[:source])
      }.count

=end