class CreateClaimMains < ActiveRecord::Migration
  def self.up
    create_table :claim_mains do |t|
      t.string :lastname
      t.string :firstname
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :city
      t.string :state
      t.string :zip
      t.string :tax_id
      t.string :division
      t.integer :h_report_year
      t.string :property_type
      t.string :property_seq
      t.string :owners_flag
      t.date :last_trans_date
      t.date :ending_trans_date
      t.string :dollars_remitted
      t.string :share_remited
      t.date :report_date
      t.string :h_firstname
      t.string :h_address1
      t.string :h_address2
      t.string :h_address3
      t.string :h_city
      t.string :h_state
      t.string :h_zip
      t.date :add_date
      t.date :update_date

      t.timestamps
    end
  end

  def self.down
    drop_table :claim_mains
  end
end
