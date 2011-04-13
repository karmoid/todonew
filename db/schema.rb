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

ActiveRecord::Schema.define(:version => 20110311082921) do

  create_table "applications", :force => true do |t|
    t.string   "code"
    t.string   "description"
    t.integer  "perimeter_id"
    t.datetime "stopped_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "branches", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "entity_id"
    t.float    "long"
    t.float    "lat"
    t.integer  "refreshed",   :default => 1
  end

  create_table "carl", :force => true do |t|
    t.string   "utilisateur", :limit => 64
    t.string   "terminal",    :limit => 64
    t.integer  "poste"
    t.datetime "debut"
    t.datetime "fin"
  end

  create_table "contacts", :force => true do |t|
    t.string   "nom"
    t.string   "prenom"
    t.string   "mail"
    t.string   "phone1"
    t.string   "phone2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "counter", :primary_key => "indice", :force => true do |t|
    t.string "tst", :limit => 10
  end

  create_table "counter_save", :id => false, :force => true do |t|
    t.integer "indice"
    t.string  "tst",    :limit => 10
  end

  create_table "databrutes", :force => true do |t|
    t.string  "agc"
    t.string  "old_srv"
    t.string  "old_inst",      :limit => 32
    t.string  "hist_inst",     :limit => 32
    t.string  "dr",            :limit => 32
    t.string  "new_inst",      :limit => 32
    t.string  "new_srv"
    t.boolean "inst_mutu"
    t.string  "alias"
    t.boolean "refreshed"
    t.string  "gps",           :limit => 32
    t.string  "typeagc",       :limit => 32
    t.integer "branch_id"
    t.integer "server_id"
    t.integer "new_server_id"
  end

  create_table "entities", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "environments", :force => true do |t|
    t.string   "description"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "event_interv_links", :force => true do |t|
    t.integer  "intervenant_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "description"
    t.integer  "operation_id"
    t.text     "note"
    t.date     "planned"
    t.date     "done"
    t.date     "cancelled"
    t.text     "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "eventable_id"
    t.string   "eventable_type"
  end

  create_table "instances", :force => true do |t|
    t.string   "sid"
    t.string   "db"
    t.integer  "server_id"
    t.integer  "branch_id"
    t.string   "description"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "environment_id"
  end

  create_table "intervenants", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "phone1"
    t.string   "phone2"
    t.integer  "entity_id"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "managers", :force => true do |t|
    t.string   "nom"
    t.string   "prenom"
    t.datetime "stopped_at"
    t.integer  "service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "metiers", :force => true do |t|
    t.string   "code"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "opegroups", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "operations", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "opegroup_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "perimeters", :force => true do |t|
    t.string   "code"
    t.string   "description"
    t.datetime "stopped_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phases", :force => true do |t|
    t.string   "code"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_demandeurs", :force => true do |t|
    t.string   "perimetre"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_managers", :force => true do |t|
    t.string   "perimetre"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projets", :force => true do |t|
    t.string   "code"
    t.string   "shortdesc"
    t.text     "longdesc"
    t.integer  "project_manager_id"
    t.integer  "project_demandeur_id"
    t.date     "create_dmd"
    t.date     "plan_mep"
    t.date     "reel_mep"
    t.integer  "phase_id"
    t.date     "lastcopil"
    t.date     "nextcopil"
    t.boolean  "planif"
    t.integer  "risque_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "risques", :force => true do |t|
    t.string   "code"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "servers", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "alias"
    t.integer  "branch_id"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", :force => true do |t|
    t.string   "code"
    t.string   "description"
    t.datetime "stopped_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temp", :force => true do |t|
    t.string  "agc"
    t.string  "ope"
    t.date    "preview"
    t.date    "done"
    t.string  "note"
    t.integer "operation_id"
    t.string  "eventable_type"
    t.integer "parent_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
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

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
