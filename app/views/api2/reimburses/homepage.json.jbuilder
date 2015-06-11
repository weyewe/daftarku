
json.success true  
 

json.reimburses @objects do |object|
	json.id 				 object.id  
  json.title       object.title
  json.description object.description 
  
  if  object.application_date.present?
    json.application_date object.application_date.to_datetime.to_s
  else
    json.application_date ""
  end
  
  json.is_submitted object.is_submitted
  if  object.is_submitted?
    json.submitted_at  object.submitted_at.to_datetime.to_s
  else
    json.submitted_at ""
  end   
  
  json.is_confirmed object.is_confirmed 
  if  object.is_confirmed?
    json.confirmed_at  object.confirmed_at.to_datetime.to_s
  else
    json.confirmed_at ""
  end   
  
  
 
  json.reimburse_details object.reimburse_details do |r_d|
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
    
  end
	
	
end


