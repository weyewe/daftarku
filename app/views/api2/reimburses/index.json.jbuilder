
json.success true  


json.reimburses @objects do |object|

  if object.first_reimburse_detail.nil? 
    json.first_receipt_mini_url   nil 
    json.first_receipt_original_url   nil
  else
    json.first_receipt_mini_url  object.first_reimburse_detail.receipt_mini_url
    json.first_receipt_original_url  object.first_reimburse_detail.receipt_original_url
  end

  
  json.updated_at object.updated_at.to_datetime.to_s
  
  json.total_approved object.total_approved
	json.id 				 object.id  
  json.title       object.title
  json.description object.description 
  
  if not object.application_date.nil? 
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
   
	
	
end


