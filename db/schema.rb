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

ActiveRecord::Schema.define(:version => 20110111045013) do

  create_table "addresses", :force => true do |t|
    t.string   "address",     :limit => 900
    t.string   "locality",    :limit => 200
    t.string   "city",        :limit => 100
    t.string   "state",       :limit => 100
    t.string   "country",     :limit => 100
    t.integer  "customer_id"
    t.integer  "pincode"
    t.integer  "mphone"
    t.integer  "ophone"
    t.integer  "hphone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.string   "firstname"
    t.string   "middlename"
    t.string   "lastname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  # unrecognized index "index_authors_on_name" with type ActiveRecord::ConnectionAdapters::IndexDefinition

  create_table "books", :force => true do |t|
    t.string   "book_no"
    t.string   "shelf_location"
    t.integer  "branch_id"
    t.integer  "catalogued_branch_id"
    t.string   "state"
    t.integer  "title_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  # unrecognized index "index_books_on_book_no" with type ActiveRecord::ConnectionAdapters::IndexDefinition

  create_table "branches", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "phone"
    t.string   "email"
    t.string   "is_a"
    t.integer  "parent_id"
    t.string   "parent_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "card_id"
  end

  create_table "cards", :force => true do |t|
    t.string   "number",        :limit => 9
    t.integer  "membership_id"
    t.string   "status",        :limit => 2
    t.date     "date_lost"
    t.date     "date_issued"
    t.date     "date_returned"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "division"
  end

  # unrecognized index "index_categories_on_name_and_division" with type ActiveRecord::ConnectionAdapters::IndexDefinition

  create_table "cities", :force => true do |t|
    t.string   "cityname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "consignments", :force => true do |t|
    t.string   "consignor"
    t.string   "consignee"
    t.integer  "origin_id"
    t.integer  "destination_id"
    t.string   "waybill_no"
    t.string   "origin_address"
    t.string   "destination_address"
    t.integer  "goods_count"
    t.integer  "goods_delivered_count"
    t.string   "state"
    t.datetime "pickup_date"
    t.datetime "delivery_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupons", :force => true do |t|
    t.string   "name"
    t.decimal  "amount",     :precision => 10, :scale => 0
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "discount",   :precision => 10, :scale => 0
  end

  create_table "coupons_plans", :id => false, :force => true do |t|
    t.integer  "coupon_id"
    t.integer  "plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", :force => true do |t|
    t.string   "title"
    t.string   "name"
    t.string   "gender",                :limit => 2
    t.date     "date_of_birth"
    t.string   "email_id"
    t.integer  "address_id"
    t.string   "general_info_level",    :limit => 2
    t.string   "email_info_level",      :limit => 2
    t.string   "address_info_level",    :limit => 2
    t.string   "book_shelf_info_level", :limit => 2
    t.string   "groups_info_level",     :limit => 2
    t.string   "favorites_info_level",  :limit => 2
    t.string   "customer_type",         :limit => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "goods", :force => true do |t|
    t.string   "book_no"
    t.integer  "title_id"
    t.integer  "ibtr_id"
    t.integer  "consignment_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ibtr_versions", :force => true do |t|
    t.integer  "ibtr_id"
    t.integer  "version"
    t.integer  "title_id"
    t.integer  "member_id"
    t.string   "card_id"
    t.integer  "branch_id"
    t.integer  "rns_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "respondent_id"
    t.integer  "reason_id"
    t.string   "comments"
  end

  # unrecognized index "index_ibtr_versions_on_ibtr_id" with type ActiveRecord::ConnectionAdapters::IndexDefinition

  create_table "ibtrs", :force => true do |t|
    t.integer  "title_id"
    t.integer  "member_id"
    t.string   "card_id"
    t.integer  "branch_id"
    t.integer  "rns_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version"
    t.string   "respondent_id"
    t.integer  "reason_id"
    t.string   "comments"
  end

  create_table "memberpayments", :force => true do |t|
    t.integer  "membership_id"
    t.integer  "customer_id"
    t.integer  "card_id"
    t.decimal  "amount",                           :precision => 10, :scale => 0
    t.string   "currency",          :limit => 4
    t.string   "transaction_type",  :limit => 50
    t.integer  "txn_branch_id"
    t.integer  "account_branch_id"
    t.integer  "plan_id"
    t.string   "remarks",           :limit => 300
    t.integer  "payment_mode"
    t.integer  "original_id"
    t.string   "status",            :limit => 4
    t.string   "payment_details",   :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", :force => true do |t|
    t.string   "name"
    t.float    "security_deposit"
    t.float    "registration_fee"
    t.float    "reading_fee"
    t.float    "magazine_fee"
    t.integer  "num_books"
    t.integer  "num_magazines"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reading_limit"
    t.boolean  "subscription"
  end

  create_table "publishers", :force => true do |t|
    t.string   "name"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  # unrecognized index "index_publishers_on_name" with type ActiveRecord::ConnectionAdapters::IndexDefinition

  create_table "signups", :force => true do |t|
    t.string   "name",                                :null => false
    t.string   "address",                             :null => false
    t.integer  "mphone"
    t.integer  "lphone"
    t.string   "email",                               :null => false
    t.string   "referrer_member_id"
    t.integer  "referrer_cust_id"
    t.integer  "plan_id",                             :null => false
    t.integer  "branch_id"
    t.integer  "signup_months",                       :null => false
    t.float    "security_deposit",                    :null => false
    t.float    "registration_fee",                    :null => false
    t.float    "reading_fee",                         :null => false
    t.float    "discount",                            :null => false
    t.float    "advance_amt",                         :null => false
    t.float    "paid_amt",                            :null => false
    t.float    "overdue_amt",                         :null => false
    t.integer  "payment_mode",                        :null => false
    t.string   "payment_ref",                         :null => false
    t.string   "membership_no"
    t.string   "application_no"
    t.string   "employee_no"
    t.integer  "created_by",                          :null => false
    t.integer  "modified_by",                         :null => false
    t.string   "flag_migrated",      :default => "U"
    t.date     "start_date",                          :null => false
    t.date     "expiry_date",                         :null => false
    t.string   "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "coupon_amt"
    t.string   "coupon_no"
    t.integer  "coupon_id"
  end

  create_table "states", :force => true do |t|
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stock", :id => false, :force => true do |t|
    t.integer "title_id"
    t.integer "branch_id"
    t.integer "in_store_cnt"
    t.integer "in_circulation_cnt"
    t.integer "unavailable_cnt"
    t.integer "total_cnt"
  end

  create_table "stockitems", :force => true do |t|
    t.integer "title_id"
    t.integer "author_id"
    t.integer "category_id"
    t.integer "publisher_id"
    t.string  "title_name"
    t.string  "isbn"
    t.decimal "price",        :precision => 10, :scale => 0
    t.string  "language"
    t.string  "edition"
    t.string  "pubyear"
    t.integer "pages"
    t.string  "binding"
  end

  # unrecognized index "index_stockitems_on_title_id" with type ActiveRecord::ConnectionAdapters::IndexDefinition

  create_table "titles", :force => true do |t|
    t.string   "title",             :null => false
    t.integer  "author_id"
    t.integer  "publisher_id"
    t.integer  "yearofpublication"
    t.integer  "edition"
    t.integer  "category_id"
    t.string   "isbn10"
    t.string   "isbn13"
    t.integer  "noofpages"
    t.string   "language"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  # unrecognized index "index_titles_on_author_id" with type ActiveRecord::ConnectionAdapters::IndexDefinition
  # unrecognized index "index_titles_on_publisher_id" with type ActiveRecord::ConnectionAdapters::IndexDefinition
  # unrecognized index "index_titles_on_title" with type ActiveRecord::ConnectionAdapters::IndexDefinition

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  # unrecognized index "index_users_on_reset_password_token" with type ActiveRecord::ConnectionAdapters::IndexDefinition
  # unrecognized index "index_users_on_username" with type ActiveRecord::ConnectionAdapters::IndexDefinition

end
