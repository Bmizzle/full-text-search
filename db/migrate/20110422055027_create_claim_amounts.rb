class CreateClaimAmounts < ActiveRecord::Migration
  def self.up
    create_table :claim_amounts do |t|
      
      t.integer :user_id, :null => false
      t.decimal :claim_main_id, :null => false, :precision => 30
      
      t.decimal :amount, :null => false, :precision => 20
      
      t.integer :tracker_user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :claim_amounts
  end
end
