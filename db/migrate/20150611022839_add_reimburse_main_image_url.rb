class AddReimburseMainImageUrl < ActiveRecord::Migration
  def change
  	add_column :reimburses , :original_main_image_url, :text 
  	add_column :reimburses , :resized_main_image_url , :text
  end
end
