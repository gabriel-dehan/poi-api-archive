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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_04_30_163805) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activations", force: :cascade do |t|
    t.bigint "sub_criterium_id"
    t.bigint "event_id"
    t.integer "impact_points_cents", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "impact_data"
    t.index ["event_id"], name: "index_activations_on_event_id"
    t.index ["sub_criterium_id"], name: "index_activations_on_sub_criterium_id"
  end

  create_table "applications", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.string "category", null: false
    t.string "video_url"
    t.text "api_public_key"
    t.text "api_private_key"
    t.string "android_url"
    t.string "ios_url"
    t.string "web_url"
    t.boolean "is_observed", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sandbox_public_key"
    t.string "sandbox_private_key"
    t.string "api_client_id"
    t.json "requested_permissions"
    t.float "rating"
    t.text "tagline"
    t.text "poi_earn_tagline"
    t.json "config", default: {}
    t.string "uid"
  end

  create_table "applications_votes", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "potential_application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["potential_application_id"], name: "index_applications_votes_on_potential_application_id"
    t.index ["user_id"], name: "index_applications_votes_on_user_id"
  end

  create_table "assigned_tasks", force: :cascade do |t|
    t.bigint "task_blueprint_id"
    t.bigint "user_id"
    t.integer "completion_count", default: 0, null: false
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_blueprint_id"], name: "index_assigned_tasks_on_task_blueprint_id"
    t.index ["user_id"], name: "index_assigned_tasks_on_user_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "goal_cents"
    t.integer "total_funded_cents", default: 0
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "active"
    t.string "tagline"
    t.string "success_label"
  end

  create_table "categorized_impacts", force: :cascade do |t|
    t.bigint "impact_id"
    t.string "category", null: false
    t.integer "level", default: 1
    t.integer "earned_points_cents", default: 0, null: false
    t.index ["impact_id"], name: "index_categorized_impacts_on_impact_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "connected_applications", force: :cascade do |t|
    t.string "email", null: false
    t.text "encrypted_password"
    t.bigint "application_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "connected"
    t.index ["application_id"], name: "index_connected_applications_on_application_id"
    t.index ["user_id"], name: "index_connected_applications_on_user_id"
  end

  create_table "criteria", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "uid", null: false
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "earned_perks", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "perk_id"
    t.string "use_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "active"
    t.datetime "expires_at"
    t.index ["perk_id"], name: "index_earned_perks_on_perk_id"
    t.index ["user_id"], name: "index_earned_perks_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "type", null: false
    t.bigint "user_id"
    t.bigint "application_id"
    t.datetime "datetime"
    t.jsonb "parameters", default: "{}", null: false
    t.integer "impact_points_cents", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.index ["application_id"], name: "index_events_on_application_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "friends_challenges", force: :cascade do |t|
    t.bigint "challenger_id"
    t.bigint "challenged_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "challenged_phone_number"
    t.string "category"
    t.datetime "end_date"
    t.integer "reward_cents", default: 0
    t.integer "goal", default: 10
    t.string "timeframe", default: "1 week"
    t.integer "score_cents", default: 0
    t.boolean "rewarded", default: false
    t.string "challenged_name"
    t.index ["challenged_id"], name: "index_friends_challenges_on_challenged_id"
    t.index ["challenger_id"], name: "index_friends_challenges_on_challenger_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "friend_id"
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "fundings", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "campaign_id"
    t.integer "amount_cents", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_fundings_on_campaign_id"
    t.index ["user_id"], name: "index_fundings_on_user_id"
  end

  create_table "gauge_cycles", force: :cascade do |t|
    t.boolean "current", default: true
    t.integer "earned_points_cents", default: 0
    t.text "events_ids", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "impactable_type"
    t.bigint "impactable_id"
    t.integer "maximum_points_cents", default: 0
    t.boolean "can_challenge", default: false
    t.index ["impactable_type", "impactable_id"], name: "index_gauge_cycles_on_impactable_type_and_impactable_id"
  end

  create_table "impacts", force: :cascade do |t|
    t.string "status", default: "baby_poi", null: false
    t.integer "earned_points_cents", default: 0, null: false
    t.integer "spent_points_cents", default: 0, null: false
    t.integer "current_points_cents", default: 0, null: false
    t.integer "level", default: 1
    t.json "levels_celebratory_sights", default: {}
  end

  create_table "invites", force: :cascade do |t|
    t.string "phone_number"
    t.string "full_name"
    t.string "status", default: "pending"
    t.bigint "invitee_id"
    t.bigint "inviter_id"
    t.index ["invitee_id"], name: "index_invites_on_invitee_id"
    t.index ["inviter_id"], name: "index_invites_on_inviter_id"
  end

  create_table "known_contacts", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "contact_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_known_contacts_on_contact_id"
    t.index ["user_id"], name: "index_known_contacts_on_user_id"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "email", null: false
    t.string "address", null: false
    t.string "url"
    t.string "phone_number"
    t.text "opening_hours"
    t.text "categories", default: [], array: true
    t.float "latitude"
    t.float "longitude"
  end

  create_table "merchants_qualifications", force: :cascade do |t|
    t.bigint "merchant_id"
    t.bigint "quality_label_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merchant_id"], name: "index_merchants_qualifications_on_merchant_id"
    t.index ["quality_label_id"], name: "index_merchants_qualifications_on_quality_label_id"
  end

  create_table "perks", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "price_cents"
    t.bigint "application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_percentage", default: false
    t.decimal "amount", default: "0.0"
    t.string "lifespan", default: "6 months"
    t.string "tagline"
    t.string "success_label"
    t.index ["application_id"], name: "index_perks_on_application_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.string "type", default: "photo"
    t.string "file"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_type", "resource_id"], name: "index_pictures_on_resource_type_and_resource_id"
  end

  create_table "potential_applications", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category", null: false
    t.string "status", default: "pending"
  end

  create_table "quality_labels", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sponsors", force: :cascade do |t|
    t.bigint "company_id"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_sponsors_on_company_id"
    t.index ["resource_type", "resource_id"], name: "index_sponsors_on_resource_type_and_resource_id"
  end

  create_table "sub_criteria", force: :cascade do |t|
    t.string "uid", null: false
    t.string "name", null: false
    t.text "description"
    t.bigint "criterium_id"
    t.json "data", default: "{}", null: false
    t.float "impact_coefficient"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["criterium_id"], name: "index_sub_criteria_on_criterium_id"
  end

  create_table "sub_criterium_fulfillments", force: :cascade do |t|
    t.string "resource_type"
    t.bigint "resource_id"
    t.bigint "sub_criterium_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_type", "resource_id"], name: "index_crit_fulfillments_on_resource_type_and_resource_id"
    t.index ["sub_criterium_id"], name: "index_sub_criterium_fulfillments_on_sub_criterium_id"
  end

  create_table "task_blueprints", force: :cascade do |t|
    t.string "type", null: false
    t.string "category", null: false
    t.string "name", null: false
    t.text "description", null: false
    t.integer "timespan"
    t.integer "reward_cents"
    t.integer "maximum_occurence"
    t.boolean "hidden", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "full_name"
    t.string "email", null: false
    t.float "latitude"
    t.float "longitude"
    t.string "referrer_code"
    t.string "referral_code"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "impact_id"
    t.bigint "users_setting_id"
    t.string "phone_number"
    t.bigint "referrer_id"
    t.boolean "admin", default: false, null: false
    t.datetime "last_level_up_notified_at"
    t.string "locale", default: "fr"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["impact_id"], name: "index_users_on_impact_id"
    t.index ["referrer_id"], name: "index_users_on_referrer_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
    t.index ["users_setting_id"], name: "index_users_on_users_setting_id"
  end

  create_table "users_settings", force: :cascade do |t|
    t.boolean "notifications_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "activations", "events"
  add_foreign_key "activations", "sub_criteria"
  add_foreign_key "applications_votes", "potential_applications"
  add_foreign_key "applications_votes", "users"
  add_foreign_key "connected_applications", "applications"
  add_foreign_key "connected_applications", "users"
  add_foreign_key "earned_perks", "perks"
  add_foreign_key "earned_perks", "users"
  add_foreign_key "events", "applications"
  add_foreign_key "events", "users"
  add_foreign_key "friends_challenges", "users", column: "challenged_id"
  add_foreign_key "friends_challenges", "users", column: "challenger_id"
  add_foreign_key "friendships", "users"
  add_foreign_key "fundings", "campaigns"
  add_foreign_key "fundings", "users"
  add_foreign_key "invites", "users", column: "invitee_id"
  add_foreign_key "invites", "users", column: "inviter_id"
  add_foreign_key "known_contacts", "users"
  add_foreign_key "known_contacts", "users", column: "contact_id"
  add_foreign_key "merchants_qualifications", "merchants"
  add_foreign_key "merchants_qualifications", "quality_labels"
  add_foreign_key "perks", "applications"
  add_foreign_key "sponsors", "companies"
  add_foreign_key "sub_criteria", "criteria"
  add_foreign_key "sub_criterium_fulfillments", "sub_criteria"
  add_foreign_key "users", "impacts"
  add_foreign_key "users", "users", column: "referrer_id"
  add_foreign_key "users", "users_settings"
end
