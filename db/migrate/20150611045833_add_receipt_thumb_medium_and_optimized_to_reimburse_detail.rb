class AddReceiptThumbMediumAndOptimizedToReimburseDetail < ActiveRecord::Migration
  def change
  	add_column :reimburse_details, :thumb_image_url, :text
  	add_column :reimburse_details, :medium_image_url, :text
  	add_column :reimburse_details, :optimized_image_url, :text
  	remove_column :reimburse_details, :receipt_mini_url 
  	remove_column :reimburse_details, :receipt_original_url 
  end
end
