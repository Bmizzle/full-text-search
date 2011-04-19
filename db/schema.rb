# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110419043818) do

  create_table "authorizations", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "claim_mains", :force => true do |t|
    t.string   "lastname"
    t.string   "firstname"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "tax_id"
    t.string   "division"
    t.integer  "h_report_year"
    t.string   "property_type"
    t.string   "property_seq"
    t.string   "owners_flag"
    t.date     "last_trans_date"
    t.date     "ending_trans_date"
    t.string   "dollars_remitted"
    t.string   "share_remited"
    t.date     "report_date"
    t.string   "h_firstname"
    t.string   "h_address1"
    t.string   "h_address2"
    t.string   "h_address3"
    t.string   "h_city"
    t.string   "h_state"
    t.string   "h_zip"
    t.date     "add_date"
    t.date     "update_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "source"
    t.string   "username"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "facebook_friends", :force => true do |t|
    t.integer  "user_id",                                     :null => false
    t.decimal  "facebook_uid", :precision => 30, :scale => 0, :null => false
    t.string   "name",                                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "facebook_statuses", :force => true do |t|
    t.integer  "user_id",                               :null => false
    t.string   "facebook_status_id",                    :null => false
    t.string   "name"
    t.string   "link"
    t.string   "caption"
    t.text     "description"
    t.string   "source"
    t.string   "status_type"
    t.boolean  "deteled",            :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "twitter_followers", :force => true do |t|
    t.integer  "user_id",                                    :null => false
    t.decimal  "twitter_id",  :precision => 30, :scale => 0, :null => false
    t.string   "name"
    t.string   "screen_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "twitter_statuses", :force => true do |t|
    t.integer  "user_id",                                          :null => false
    t.decimal  "twitter_status_id", :precision => 30, :scale => 0, :null => false
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "perishable_token"
    t.integer  "login_count",        :default => 0
    t.integer  "failed_login_count", :default => 0
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "active",             :default => false, :null => false
    t.boolean  "social_login",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
