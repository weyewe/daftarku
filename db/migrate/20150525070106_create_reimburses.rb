class CreateReimburses < ActiveRecord::Migration
  def change
    create_table :reimburses do |t| 
      t.integer :user_id
      t.string :title
      t.text :description
      t.datetime :application_date 
      t.boolean :is_submitted, :default => false 
      t.datetime :submitted_at 
      t.string :destination_email 
      t.boolean :is_confirmed, :default => false
      t.datetime :confirmed_at 
      t.timestamps
    end
  end
end
