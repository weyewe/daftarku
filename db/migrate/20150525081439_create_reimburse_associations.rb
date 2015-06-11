class CreateReimburseAssociations < ActiveRecord::Migration
  def change
    create_table :reimburse_associations do |t|
      t.integer :association_status
      t.integer :user_id 
      t.integer :reimburse_id 
      t.timestamps
    end
  end
end
