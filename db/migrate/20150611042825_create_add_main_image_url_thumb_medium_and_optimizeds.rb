class CreateAddMainImageUrlThumbMediumAndOptimizeds < ActiveRecord::Migration
  def change
    create_table :add_main_image_url_thumb_medium_and_optimizeds do |t|

    add_column :reimburses , :medium_image_url, :text 
  	add_column :reimburses , :thumb_image_url , :text
  	add_column :reimburses , :optimized_image_url , :text

  	remove_column :reimburses , :original_main_image_url 
  	remove_column :reimburses , :resized_main_image_url  

      t.timestamps
    end
  end
end
