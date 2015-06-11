
json.success true  
json.reimburse_id 				 @reimburse.id  
json.reimburse_title       @reimburse.title
json.reimburse_description @reimburse.description 

if  @reimburse.application_date.present?
  json.reimburse_application_date @reimburse.application_date.to_datetime.to_s
else
  json.reimburse_application_date ""
end

json.reimburse_is_submitted @reimburse.is_submitted
if  @reimburse.is_submitted?
  json.reimburse_submitted_at  @reimburse.submitted_at.to_datetime.to_s
else
  json.reimburse_submitted_at ""
end   

json.reimburse_is_confirmed @reimburse.is_confirmed 
if  @reimburse.is_confirmed?
  json.reimburse_confirmed_at  @reimburse.confirmed_at.to_datetime.to_s
else
  json.reimburse_confirmed_at ""
end   

 

json.reimburse_details @objects do |r_d|
    json.updated_at r_d.updated_at.to_datetime.to_s
    json.id           r_d.id 
    json.amount       r_d.amount 
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


