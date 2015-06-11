class AddUrlToReimburseDetail < ActiveRecord::Migration
  def change
  	add_column :reimburse_details, :website_url, :text
  end
end
