# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 2) do

  create_table "accounts", :force => true do |t|
    t.string   "username",         :limit => 25,  :default => "",            :null => false
    t.string   "contact_name",     :limit => 50,  :default => "",            :null => false
    t.string   "email",            :limit => 50,  :default => "",            :null => false
    t.string   "password",         :limit => 18,  :default => "",            :null => false
    t.text     "note"
    t.string   "business_name",    :limit => 200, :default => "",            :null => false
    t.string   "business_address", :limit => 200, :default => "",            :null => false
    t.string   "phone",            :limit => 25,  :default => "",            :null => false
    t.string   "cellphone",        :limit => 25,  :default => "",            :null => false
    t.string   "country",          :limit => 25,  :default => "New Zealand", :null => false
    t.string   "shipping_address", :limit => 200
    t.integer  "suspended",        :limit => 1,   :default => 0,             :null => false
    t.integer  "price_level_id",   :limit => 10,  :default => 0,             :null => false
    t.datetime "time_created"
    t.string   "fax_number",       :limit => 25
    t.integer  "special_offers",   :limit => 1,   :default => 0,             :null => false
    t.integer  "agree_terms",      :limit => 1,   :default => 0,             :null => false
    t.integer  "account_type",     :limit => 1,   :default => 0,             :null => false
    t.string   "postcode",         :limit => 50,  :default => "",            :null => false
  end

  create_table "administrators", :force => true do |t|
    t.string  "username", :limit => 18, :default => "", :null => false
    t.string  "password", :limit => 18, :default => "", :null => false
    t.integer "level",                  :default => 0,  :null => false
  end

  create_table "categories", :force => true do |t|
    t.string  "name",        :limit => 45,  :default => "", :null => false
    t.integer "p_id",        :limit => 10,  :default => 0,  :null => false
    t.integer "level_order", :limit => 1,   :default => 0
    t.string  "label",       :limit => 250, :default => "", :null => false
    t.integer "level_num",                  :default => 0,  :null => false
  end

  create_table "charities", :force => true do |t|
    t.string "title", :limit => 200, :default => "", :null => false
  end

  create_table "freightoptions", :force => true do |t|
    t.string "name",  :limit => 100, :default => "enter an option name", :null => false
    t.float  "price",                :default => 0.0,                    :null => false
    t.text   "note",                                                     :null => false
  end

  create_table "imageobjects", :force => true do |t|
    t.datetime "created_at"
    t.string   "name",       :limit => 150
    t.string   "image",      :limit => 200
  end

  create_table "orderitems", :force => true do |t|
    t.integer "order_id",         :limit => 10, :default => 0,   :null => false
    t.integer "product_id",       :limit => 10, :default => 0,   :null => false
    t.float   "price_in_order",                 :default => 0.0, :null => false
    t.integer "quantity",         :limit => 10, :default => 0,   :null => false
    t.integer "quantity_shipped",               :default => 0,   :null => false
  end

  create_table "orders", :force => true do |t|
    t.datetime "time_created"
    t.integer  "customer_id",               :limit => 10,  :default => 0,            :null => false
    t.string   "island",                    :limit => 6,   :default => "",           :null => false
    t.string   "is_rural",                  :limit => 6,   :default => "",           :null => false
    t.text     "shipping_address",                                                   :null => false
    t.float    "suggested_freight_cost",                   :default => 0.0,          :null => false
    t.text     "suggested_freight_options",                                          :null => false
    t.datetime "last_time_of_sentmail"
    t.text     "note",                                                               :null => false
    t.string   "status",                    :limit => 45,  :default => "",           :null => false
    t.string   "date_shipped",              :limit => 25,  :default => "dd/mm/yyyy"
    t.string   "track_numbers",                            :default => "n/a"
    t.string   "arrival_date",              :limit => 25,  :default => "dd/mm/yyyy"
    t.string   "postcode",                  :limit => 8,   :default => "",           :null => false
    t.string   "donee",                     :limit => 200
  end

  create_table "pages", :force => true do |t|
    t.string   "title",      :default => "", :null => false
    t.text     "value",                      :null => false
    t.datetime "created_at"
  end

  create_table "pricelevels", :force => true do |t|
    t.string  "title",               :limit => 100, :default => "A price level", :null => false
    t.integer "discount_percentage", :limit => 10,  :default => 0,               :null => false
    t.text    "note"
  end

  create_table "pricelevels_matrix", :force => true do |t|
    t.integer "pricelevel_id", :default => 0,   :null => false
    t.integer "product_id",    :default => 0,   :null => false
    t.float   "price",         :default => 0.0, :null => false
  end

  create_table "product_condition_relation", :force => true do |t|
    t.integer "pid", :limit => 10
    t.integer "cid", :limit => 10
  end

  create_table "product_warranty_relation", :force => true do |t|
    t.integer "pid", :limit => 10
    t.integer "wid", :limit => 10
  end

  create_table "productconditions", :force => true do |t|
    t.string "condition", :limit => 50, :default => "", :null => false
  end

  create_table "productimages", :force => true do |t|
    t.string  "image",      :limit => 200
    t.integer "product_id", :limit => 10,  :default => 0, :null => false
  end

  create_table "products", :force => true do |t|
    t.datetime "time_created"
    t.float    "price",                            :default => 0.0, :null => false
    t.text     "details",                                           :null => false
    t.integer  "delivery",          :limit => 10,  :default => 0,   :null => false
    t.integer  "stock_level",       :limit => 10,  :default => 1,   :null => false
    t.integer  "warranty_id",       :limit => 10,  :default => 0
    t.integer  "condition_id",      :limit => 10,  :default => 0
    t.string   "title",             :limit => 200, :default => "",  :null => false
    t.integer  "category_id",       :limit => 10,  :default => 1,   :null => false
    t.integer  "category_id_fix_1",                :default => -1
    t.integer  "category_id_fix_2",                :default => -1
    t.integer  "freightoption_id",  :limit => 10,  :default => 1,   :null => false
    t.text     "labels",                                            :null => false
    t.integer  "views",                            :default => 0
    t.float    "donation",                         :default => 0.0
  end

  create_table "productwarranties", :force => true do |t|
    t.string "warranty", :limit => 50, :default => "", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :default => "", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "shops", :force => true do |t|
    t.string  "shop_name",                           :limit => 200, :default => "",        :null => false
    t.text    "header_message",                                                            :null => false
    t.string  "version",                             :limit => 10,  :default => "",        :null => false
    t.integer "allow_donation",                                     :default => 0,         :null => false
    t.string  "def_template_name",                   :limit => 50,  :default => "default"
    t.string  "tax_name",                            :limit => 25
    t.float   "tax_rate",                                           :default => 0.0,       :null => false
    t.integer "is_tax_incl_when_adding_new_product",                :default => 1,         :null => false
    t.string  "install_dir_name",                    :limit => 200
    t.string  "admin_email",                         :limit => 200
    t.string  "company_name",                        :limit => 200
    t.text    "b_addr"
    t.string  "b_phone",                             :limit => 200
    t.string  "b_mobile",                            :limit => 200
    t.string  "b_bank_acct",                         :limit => 200
    t.string  "b_website"
  end

  create_table "tabs", :force => true do |t|
    t.string  "name",     :limit => 50, :default => "None", :null => false
    t.integer "visible",                :default => 1,      :null => false
    t.integer "position",               :default => 0,      :null => false
  end

end
