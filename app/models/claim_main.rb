class ClaimMain < ActiveRecord::Base
  
  has_many :claim_amounts
    
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
  
  def self.twitter_share(val)
    id = val[:id]
    screen_name= val[:screen_name]
    tracker_user_id = val[:tracker_user_id]
    name = val[:name] 
        
    claim_main = ClaimMain.find(id)
    
    #check amount is claim or not   
    claim_amount = ClaimAmount.where(:claim_main_id => id, :user_id => tracker_user_id).first    
    if !claim_amount.nil?
      @text = "I found $#{claim_main.dollars_remitted.to_f} on ClaimVille.com. Find you missing money"
    else
      @text = "I found $#{claim_main.dollars_remitted.to_f} on ClaimVille.com for @#{screen_name} check out" if !screen_name.nil?
      @text = "I found $#{claim_main.dollars_remitted.to_f} on ClaimVille.com for #{name} check out" if screen_name.nil?
    end
    
    @text
  end
  
end
