json.success true 

json.reimburse_associations @objects do |object| 
  json.id       				object.id
  json.updated_at object.updated_at.to_datetime.to_s
 

  json.user_id					object.user_id
  json.user_mini_avatar_url 	object.reimburse.user.mini_avatar_url 
  json.reimburse_id 			object.reimburse_id
  json.reimburse_title 			object.reimburse.title 
  json.reimburse_description 	object.reimburse.description  
  json.reimburse_total_approved object.reimburse.total_approved

  if  object.reimburse.application_date.present?
    json.reimburse_application_date 		object.reimburse.application_date.to_datetime.to_s
  else
    json.reimburse_application_date ""
  end

  json.reimburse_is_submitted 				object.reimburse.is_submitted
  if  object.reimburse.is_submitted?
    json.reimburse_submitted_at  			object.reimburse.submitted_at.to_datetime.to_s
  else
    json.reimburse_ubmitted_at ""
  end   

  json.reimburse_is_confirmed 				object.reimburse.is_confirmed 
  if  object.reimburse.is_confirmed?
    json.reimburse_confirmed_at  			object.reimburse.confirmed_at.to_datetime.to_s
  else
    json.reimburse_confirmed_at ""
  end   

  json.reimburse_details object.reimburse.reimburse_details do |r_d|

    json.id r_d.id
    json.reimburse_id r_d.reimburse_id 
    json.title r_d.title 
    json.description r_d.description
    
    if r_d.transaction_datetime.present?
      json.transaction_datetime r_d.transaction_datetime.to_datetime.to_s
    else
      json.transaction_datetime  ""
    end
    
    json.receipt_mini_url r_d.receipt_mini_url
    json.receipt_original_url r_d.receipt_original_url 
    json.is_rejected r_d.is_rejected 
    
    json.total_comment r_d.comments.count 
    json.amount r_d.amount
    
  end

end

