
json.success true  

json.reimburse_id @reimburse_detail.reimburse_id 
json.reimburse_title @reimburse_detail.reimburse.title 
json.title @reimburse_detail.title 
json.description @reimburse_detail.description

if @reimburse_detail.transaction_datetime.present?
  json.transaction_datetime @reimburse_detail.transaction_datetime.to_datetime.to_s
else
  json.transaction_datetime  ""
end

json.receipt_mini_url @reimburse_detail.receipt_mini_url
json.receipt_original_url @reimburse_detail.receipt_original_url 
json.is_rejected @reimburse_detail.is_rejected 

json.total_comment @reimburse_detail.comments.count 

json.id @reimburse_detail.id 
json.amount @reimburse_detail.amount 


json.comments @objects do |comment|
	json.updated_at 		comment.updated_at.to_datetime.to_s
	
  json.user_id comment.user_id
  json.user_name comment.user.name 
  json.user_email comment.user.email 

  json.mini_avatar_url comment.user.mini_avatar_url
  json.original_avatar_url comment.user.original_avatar_url 
  json.id comment.id 
  json.content comment.content 
  
end


