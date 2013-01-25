# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20130125152937) do

  create_table "iterations", :force => true do |t|
    t.integer  "project_id"
    t.integer  "number"
    t.datetime "start"
    t.datetime "finish"
    t.string   "kind"
    t.date     "taken_on"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "iterations", ["project_id", "kind"], :name => "index_iterations_on_project_id_and_kind"

  create_table "labelings", :force => true do |t|
    t.integer  "story_id"
    t.integer  "project_id"
    t.integer  "label_id"
    t.date     "taken_on"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "labelings", ["label_id"], :name => "index_labelings_on_label_id"
  add_index "labelings", ["project_id"], :name => "index_labelings_on_project_id"
  add_index "labelings", ["story_id"], :name => "index_labelings_on_story_id"

  create_table "labels", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "labels", ["name"], :name => "index_labels_on_name"

  create_table "projects", :force => true do |t|
    t.integer  "tracker_id"
    t.integer  "user_id"
    t.string   "name"
    t.text     "all_labels",       :default => "", :null => false
    t.text     "enabled_labels",   :default => "", :null => false
    t.boolean  "enabled"
    t.datetime "last_snapshot_at"
    t.integer  "current_velocity"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "projects", ["user_id"], :name => "index_projects_on_user_id"

  create_table "stories", :force => true do |t|
    t.integer  "project_id"
    t.integer  "iteration_id"
    t.integer  "estimate"
    t.string   "name"
    t.string   "tracker_id"
    t.string   "url"
    t.string   "current_state"
    t.string   "story_type"
    t.string   "requested_by"
    t.string   "owned_by"
    t.string   "tracker_labels"
    t.datetime "tracker_created_at"
    t.date     "taken_on"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "stories", ["project_id", "iteration_id"], :name => "index_stories_on_project_id_and_iteration_id"
  add_index "stories", ["project_id", "taken_on"], :name => "index_stories_on_project_id_and_taken_on"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.string   "tracker_token"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end