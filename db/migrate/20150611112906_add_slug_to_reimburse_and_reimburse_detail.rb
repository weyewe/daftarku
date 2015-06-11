class AddSlugToReimburseAndReimburseDetail < ActiveRecord::Migration
  def change
  	add_column :reimburses, :slug, :string
  	add_column :reimburse_details, :slug, :string
  end
end
