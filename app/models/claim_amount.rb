class ClaimAmount < ActiveRecord::Base
  
  belongs_to :claim_main
  belongs_to :user
end
