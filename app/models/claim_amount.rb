class ClaimAmount < ActiveRecord::Base
  
  belongs_to :claim_main
  belongs_to :user
  
  validates_uniqueness_of :claim_main_id
end
