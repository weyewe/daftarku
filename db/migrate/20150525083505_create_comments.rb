class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :reimburse_detail_id 
      t.text :content
      t.integer :user_id 
      t.datetime :post_datetime
      
      t.timestamps
    end
  end
end
