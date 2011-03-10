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

ActiveRecord::Schema.define(:version => 20110223100734) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id",    :precision => 38, :scale => 0
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "batches", :force => true do |t|
    t.string   "batch_type"
    t.string   "assigned_to"
    t.string   "state"
    t.integer  "item_count",   :precision => 38, :scale => 0
    t.integer  "closed_count", :precision => 38, :scale => 0
    t.datetime "expires_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blogs", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at", :limit => 6
    t.timestamp "updated_at", :limit => 6
    t.datetime  "start"
    t.datetime  "start2"
  end

  create_table "consignments", :force => true do |t|
    t.string   "consignor"
    t.string   "consignee"
    t.integer  "origin_id",             :precision => 38, :scale => 0
    t.integer  "destination_id",        :precision => 38, :scale => 0
    t.string   "waybill_no"
    t.string   "origin_address"
    t.string   "destination_address"
    t.integer  "goods_count",           :precision => 38, :scale => 0
    t.integer  "goods_delivered_count", :precision => 38, :scale => 0
    t.string   "state"
    t.datetime "pickup_date"
    t.datetime "delivery_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kind"
  end

  create_table "coupons", :force => true do |t|
    t.string   "name"
    t.integer  "amount",     :precision => 38, :scale => 0
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "discount",   :precision => 38, :scale => 0
  end

  create_table "coupons_plans", :id => false, :force => true do |t|
    t.integer  "coupon_id",  :precision => 38, :scale => 0
    t.integer  "plan_id",    :precision => 38, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fixed_titles", :id => false, :force => true do |t|
    t.integer   "title_id",                :precision => 38, :scale => 0
    t.timestamp "date_fixed", :limit => 6
  end

  create_table "goods", :force => true do |t|
    t.string   "book_no"
    t.integer  "title_id",       :precision => 38, :scale => 0
    t.integer  "ibtr_id",        :precision => 38, :scale => 0
    t.integer  "consignment_id", :precision => 38, :scale => 0
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ibt_hidden_reqs", :force => true do |t|
    t.string    "category"
    t.string    "rack"
    t.string    "shelf"
    t.timestamp "created_at",    :limit => 6
    t.timestamp "updated_at",    :limit => 6
    t.integer   "respondent_id",              :precision => 38, :scale => 0
    t.integer   "title_id",                   :precision => 38, :scale => 0
  end

  create_table "ibt_reassigns", :force => true do |t|
    t.integer  "batch_id",      :precision => 38, :scale => 0
    t.integer  "title_id",      :precision => 38, :scale => 0
    t.integer  "respondent_id", :precision => 38, :scale => 0
    t.integer  "assigned_cnt",  :precision => 38, :scale => 0
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ibt_search_criterias", :force => true do |t|
    t.integer   "respondent_id",              :precision => 38, :scale => 0
    t.timestamp "time_basis",    :limit => 6
    t.timestamp "created_at",    :limit => 6
    t.timestamp "updated_at",    :limit => 6
  end

  create_table "ibt_sorts", :force => true do |t|
    t.integer   "book_no",                      :precision => 38, :scale => 0
    t.integer   "ibtr_id",                      :precision => 38, :scale => 0
    t.integer   "consignment_id",               :precision => 38, :scale => 0
    t.string    "isbn"
    t.string    "flg_no_isbn"
    t.string    "flg_repeat_sort"
    t.string    "flg_success"
    t.timestamp "created_at",      :limit => 6
    t.timestamp "updated_at",      :limit => 6
  end

  create_table "ibtr_versions", :force => true do |t|
    t.integer   "ibtr_id",                    :precision => 38, :scale => 0
    t.integer   "version",                    :precision => 38, :scale => 0
    t.integer   "title_id",                   :precision => 38, :scale => 0
    t.integer   "member_id",                  :precision => 38, :scale => 0
    t.string    "card_id"
    t.integer   "branch_id",                  :precision => 38, :scale => 0
    t.integer   "rns_id",                     :precision => 38, :scale => 0
    t.string    "state"
    t.timestamp "created_at",    :limit => 6
    t.timestamp "updated_at",    :limit => 6
    t.string    "respondent_id"
    t.integer   "reason_id",                  :precision => 38, :scale => 0
    t.string    "comments"
    t.integer   "book_no",                    :precision => 38, :scale => 0
    t.string    "po_no"
    t.string    "kind"
  end

  create_table "ibtr_versions_dt", :id => false, :force => true do |t|
    t.integer   "id",                         :precision => 38, :scale => 0, :null => false
    t.integer   "ibtr_id",                    :precision => 38, :scale => 0
    t.integer   "version",                    :precision => 38, :scale => 0
    t.integer   "title_id",                   :precision => 38, :scale => 0
    t.integer   "member_id",                  :precision => 38, :scale => 0
    t.string    "card_id"
    t.integer   "branch_id",                  :precision => 38, :scale => 0
    t.integer   "rns_id",                     :precision => 38, :scale => 0
    t.string    "state"
    t.timestamp "created_at",    :limit => 6
    t.timestamp "updated_at",    :limit => 6
    t.string    "respondent_id"
    t.integer   "reason_id",                  :precision => 38, :scale => 0
    t.string    "comments"
  end

  create_table "ibtrs", :force => true do |t|
    t.integer   "title_id",                   :precision => 38, :scale => 0
    t.integer   "member_id",                  :precision => 38, :scale => 0
    t.string    "card_id"
    t.integer   "branch_id",                  :precision => 38, :scale => 0
    t.integer   "rns_id",                     :precision => 38, :scale => 0
    t.string    "state"
    t.timestamp "created_at",    :limit => 6
    t.timestamp "updated_at",    :limit => 6
    t.integer   "version",                    :precision => 38, :scale => 0
    t.string    "respondent_id"
    t.integer   "reason_id",                  :precision => 38, :scale => 0
    t.string    "comments"
    t.integer   "book_no",                    :precision => 38, :scale => 0
    t.string    "po_no"
    t.string    "kind"
  end

  add_index "ibtrs", ["card_id"], :name => "in_ibtrs_3"
  add_index "ibtrs", ["member_id"], :name => "in_ibtrs_4"
  add_index "ibtrs", ["rns_id"], :name => "in_ibtrs_1"
  add_index "ibtrs", ["state"], :name => "in_ibtrs_2"

  create_table "ibtrs_dt", :id => false, :force => true do |t|
    t.integer   "id",                         :precision => 38, :scale => 0, :null => false
    t.integer   "title_id",                   :precision => 38, :scale => 0
    t.integer   "member_id",                  :precision => 38, :scale => 0
    t.string    "card_id"
    t.integer   "branch_id",                  :precision => 38, :scale => 0
    t.integer   "rns_id",                     :precision => 38, :scale => 0
    t.string    "state"
    t.timestamp "created_at",    :limit => 6
    t.timestamp "updated_at",    :limit => 6
    t.integer   "version",                    :precision => 38, :scale => 0
    t.string    "respondent_id"
    t.integer   "reason_id",                  :precision => 38, :scale => 0
    t.string    "comments"
  end

  create_table "plans", :force => true do |t|
    t.string   "name"
    t.decimal  "security_deposit"
    t.decimal  "registration_fee"
    t.decimal  "reading_fee"
    t.decimal  "magazine_fee"
    t.integer  "num_books",        :precision => 38, :scale => 0
    t.integer  "num_magazines",    :precision => 38, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reading_limit",    :precision => 38, :scale => 0
    t.boolean  "subscription",     :precision => 1,  :scale => 0
  end

  create_table "read_next_shelf", :id => false, :force => true do |t|
    t.integer   "memberid",         :limit => 10,  :precision => 10, :scale => 0
    t.string    "membercardno",     :limit => 15
    t.integer   "bookid",           :limit => 10,  :precision => 10, :scale => 0
    t.timestamp "daterequested",    :limit => 6
    t.string    "status",           :limit => 50
    t.timestamp "dateissued",       :limit => 6
    t.timestamp "datedelevered",    :limit => 6
    t.timestamp "datecollected",    :limit => 6
    t.integer   "readingperiority", :limit => 10,  :precision => 10, :scale => 0
    t.integer   "titleid",          :limit => 10,  :precision => 10, :scale => 0
    t.decimal   "requestid",                                                      :null => false
    t.decimal   "requestingbranch"
    t.decimal   "fulfillingbranch"
    t.decimal   "slotnumber"
    t.decimal   "drpassword"
    t.decimal   "booknumber"
    t.decimal   "reason"
    t.string    "remarks",          :limit => 200
    t.timestamp "iblastupdatedate", :limit => 6
    t.string    "ddstatus",         :limit => 2
    t.string    "procstatus",       :limit => 2
    t.integer   "orderid",          :limit => 11,  :precision => 11, :scale => 0
    t.datetime  "returndate"
    t.string    "ponumber",         :limit => 200
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id", :precision => 38, :scale => 0
    t.integer "user_id", :precision => 38, :scale => 0
  end

  create_table "signups", :force => true do |t|
    t.string    "name",                                                                             :null => false
    t.string    "address",                                                                          :null => false
    t.integer   "mphone",                           :precision => 38, :scale => 0
    t.integer   "lphone",                           :precision => 38, :scale => 0
    t.string    "email",                                                                            :null => false
    t.string    "referrer_member_id"
    t.integer   "referrer_cust_id",                 :precision => 38, :scale => 0
    t.integer   "plan_id",                          :precision => 38, :scale => 0,                  :null => false
    t.integer   "branch_id",                        :precision => 38, :scale => 0
    t.integer   "signup_months",                    :precision => 38, :scale => 0,                  :null => false
    t.decimal   "security_deposit",                                                                 :null => false
    t.decimal   "registration_fee",                                                                 :null => false
    t.decimal   "reading_fee",                                                                      :null => false
    t.decimal   "discount",                                                                         :null => false
    t.decimal   "advance_amt",                                                                      :null => false
    t.decimal   "paid_amt",                                                                         :null => false
    t.decimal   "overdue_amt",                                                                      :null => false
    t.integer   "payment_mode",                     :precision => 38, :scale => 0,                  :null => false
    t.string    "payment_ref",                                                                      :null => false
    t.string    "membership_no"
    t.string    "application_no"
    t.string    "employee_no"
    t.integer   "created_by",                       :precision => 38, :scale => 0,                  :null => false
    t.integer   "modified_by",                      :precision => 38, :scale => 0,                  :null => false
    t.string    "flag_migrated",                                                   :default => "U"
    t.datetime  "start_date",                                                                       :null => false
    t.datetime  "expiry_date",                                                                      :null => false
    t.string    "remarks"
    t.timestamp "created_at",         :limit => 6
    t.timestamp "updated_at",         :limit => 6
    t.decimal   "coupon_amt"
    t.string    "coupon_no",          :limit => 20
    t.integer   "coupon_id",                        :precision => 38, :scale => 0
  end

  create_table "signups_dt", :id => false, :force => true do |t|
    t.integer  "id",                               :precision => 38, :scale => 0, :null => false
    t.string   "name",                                                            :null => false
    t.string   "address",                                                         :null => false
    t.integer  "mphone",                           :precision => 38, :scale => 0
    t.integer  "lphone",                           :precision => 38, :scale => 0
    t.string   "email",                                                           :null => false
    t.string   "referrer_member_id"
    t.integer  "referrer_cust_id",                 :precision => 38, :scale => 0
    t.integer  "plan_id",                          :precision => 38, :scale => 0, :null => false
    t.integer  "branch_id",                        :precision => 38, :scale => 0
    t.integer  "signup_months",                    :precision => 38, :scale => 0, :null => false
    t.decimal  "security_deposit",                                                :null => false
    t.decimal  "registration_fee",                                                :null => false
    t.decimal  "reading_fee",                                                     :null => false
    t.decimal  "discount",                                                        :null => false
    t.decimal  "advance_amt",                                                     :null => false
    t.decimal  "paid_amt",                                                        :null => false
    t.decimal  "overdue_amt",                                                     :null => false
    t.integer  "payment_mode",                     :precision => 38, :scale => 0, :null => false
    t.string   "payment_ref",                                                     :null => false
    t.string   "membership_no"
    t.string   "application_no"
    t.string   "employee_no"
    t.integer  "created_by",                       :precision => 38, :scale => 0, :null => false
    t.integer  "modified_by",                      :precision => 38, :scale => 0, :null => false
    t.string   "flag_migrated"
    t.datetime "start_date",                                                      :null => false
    t.datetime "expiry_date",                                                     :null => false
    t.string   "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "coupon_amt"
    t.string   "coupon_no",          :limit => 20
    t.integer  "coupon_id",                        :precision => 38, :scale => 0
  end

  create_table "stock_racks_shelves", :id => false, :force => true do |t|
    t.integer "title_id",        :limit => 10,  :precision => 10, :scale => 0, :null => false
    t.integer "book_branch_id",  :limit => nil,                                :null => false
    t.string  "category",        :limit => 400
    t.string  "rack",            :limit => 400
    t.string  "shelf",           :limit => 100
    t.decimal "count_per_shelf"
  end

  add_index "stock_racks_shelves", ["title_id", "book_branch_id"], :name => "idx_stock_racks_shelves_1"

  create_table "test", :id => false, :force => true do |t|
    t.timestamp "a", :limit => 6
    t.timestamp "b", :limit => 6
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email",                                                              :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128,                                :default => ""
    t.string   "password_salt",                                                      :default => ""
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :precision => 38, :scale => 0, :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end