class CreateReimburseDetails < ActiveRecord::Migration
  def change
    create_table :reimburse_details do |t|
      
    
      t.integer :reimburse_id
      t.string :title
      t.text :description 
      t.datetime :transaction_datetime 
      
      t.text :receipt_mini_url 
      t.text :receipt_original_url 
      t.decimal  :amount ,       precision: 14, scale: 2, default: 0.0

    
      t.boolean :is_rejected, :default => false 
      t.timestamps
    end
  end
end
