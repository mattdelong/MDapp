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

ActiveRecord::Schema.define(:version => 20120418210906) do

  create_table "messages", :force => true do |t|
    t.text     "content"
    t.boolean  "is_read",     :default => false
    t.boolean  "is_private",  :default => false
    t.boolean  "is_archived", :default => false
    t.integer  "target_id"
    t.string   "target_type"
    t.integer  "user_id"
    t.integer  "proposal_id"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["is_private", "target_type", "target_id"], :name => "comments_by_type"
  add_index "messages", ["is_read", "is_private", "target_type", "target_id"], :name => "comments_by_type_by_read"
  add_index "messages", ["topic_id"], :name => "index_messages_on_topic_id"
  add_index "messages", ["user_id", "is_private", "is_archived", "proposal_id"], :name => "comments_by_archived_by_proposal"
  add_index "messages", ["user_id", "is_private", "target_type", "target_id"], :name => "comments_by_type_by_user"
  add_index "messages", ["user_id", "proposal_id"], :name => "index_messages_on_user_id_and_proposal_id"
  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "planner_users", :force => true do |t|
    t.integer  "planner_id"
    t.string   "user_email"
    t.string   "role_identifier"
    t.string   "member_title",    :default => ""
    t.boolean  "confirmed",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "planner_users", ["confirmed"], :name => "index_planner_users_on_confirmed"
  add_index "planner_users", ["planner_id", "confirmed"], :name => "index_planner_users_on_planner_id_and_confirmed"
  add_index "planner_users", ["planner_id", "user_email"], :name => "index_planner_users_on_planner_id_and_user_email"
  add_index "planner_users", ["planner_id"], :name => "index_planner_users_on_planner_id"
  add_index "planner_users", ["user_email"], :name => "index_planner_users_on_user_email"

  create_table "planners", :force => true do |t|
    t.string   "name"
    t.string   "company"
    t.string   "email"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "facebook_url"
    t.string   "twitter_url"
    t.string   "market_identifier"
    t.string   "location"
    t.text     "description"
    t.string   "web_url"
    t.integer  "comments_count",    :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "planners", ["location"], :name => "index_planners_on_location"
  add_index "planners", ["market_identifier", "location"], :name => "index_planners_on_market_identifier_and_location"
  add_index "planners", ["name"], :name => "index_planners_on_name", :unique => true

  create_table "proposal_for_venues", :id => false, :force => true do |t|
    t.integer  "proposal_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "proposal_for_venues", ["proposal_id", "user_id"], :name => "index_proposal_for_venues_on_proposal_id_and_user_id"
  add_index "proposal_for_venues", ["proposal_id"], :name => "index_proposal_for_venues_on_proposal_id"
  add_index "proposal_for_venues", ["user_id"], :name => "index_proposal_for_venues_on_user_id"

  create_table "proposals", :force => true do |t|
    t.string   "proposal_stage_identifier"
    t.string   "event_title"
    t.string   "num_guests"
    t.string   "event_host_organization"
    t.string   "event_organizer"
    t.string   "event_type"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "date_firm"
    t.string   "event_frequency"
    t.string   "event_objectives"
    t.string   "event_history"
    t.text     "event_description"
    t.integer  "budget_amount",             :default => 0
    t.date     "response_by"
    t.string   "preferred_venue_type"
    t.boolean  "catering"
    t.boolean  "alcohol"
    t.boolean  "parking"
    t.boolean  "wifi"
    t.boolean  "av_equipment"
    t.boolean  "dining"
    t.boolean  "outside_area"
    t.boolean  "insurance_required"
    t.integer  "planner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "proposals", ["planner_id"], :name => "index_proposals_on_planner_id"
  add_index "proposals", ["proposal_stage_identifier"], :name => "index_proposals_on_proposal_stage_identifier"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "name"
    t.string   "location"
    t.string   "authentication_token"
    t.integer  "comments_count"
    t.integer  "messages_count"
    t.boolean  "is_admin"
    t.string   "role"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "venue_profiles", :force => true do |t|
    t.string   "tagline"
    t.string   "venue_type"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "venue_profiles", ["user_id"], :name => "index_venue_profiles_on_user_id"

end
