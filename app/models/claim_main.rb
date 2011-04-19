class ClaimMain < ActiveRecord::Base
  
  searchable :auto_index => true do
    text :lastname, :firstname
    text :address1, :address2, :address3, :city, :state, :zip    
    text :tax_id, :division, :h_report_year, :property_type, :property_seq, :owners_flag
    date :last_trans_date, :ending_trans_date
    text :dollars_remitted, :share_remited
    date :report_date
    text :h_firstname, :h_address1, :h_address2, :h_address3, :h_city, :h_state, :h_zip
    date :add_date, :update_date
  end
end
