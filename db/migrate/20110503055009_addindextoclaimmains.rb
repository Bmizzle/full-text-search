class Addindextoclaimmains < ActiveRecord::Migration
  def self.up
    add_index :claim_mains, :lastname
    add_index :claim_mains, :firstname
    add_index :claim_mains, :city    
    add_index :claim_mains, :state
    add_index :claim_mains, :zip
  end

  def self.down
    remove_index :claim_mains, :lastname
    remove_index :claim_mains, :firstname
    remove_index :claim_mains, :city    
    remove_index :claim_mains, :state
    remove_index :claim_mains, :zip
  end
end
