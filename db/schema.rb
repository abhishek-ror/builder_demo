# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_08_14_071015) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_categories", force: :cascade do |t|
    t.integer "account_id"
    t.integer "category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "accounts", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "full_phone_number"
    t.integer "country_code"
    t.bigint "phone_number"
    t.string "email"
    t.boolean "activated", default: false, null: false
    t.string "device_id"
    t.text "unique_auth_id"
    t.string "password_digest"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_name"
    t.string "platform"
    t.string "user_type"
    t.integer "app_language_id"
    t.datetime "last_visit_at"
    t.boolean "is_blacklisted", default: false
    t.date "suspend_until"
    t.integer "status", default: 0, null: false
    t.string "stripe_id"
    t.string "stripe_subscription_id"
    t.datetime "stripe_subscription_date"
    t.integer "role_id"
    t.string "full_name"
    t.integer "gender"
    t.date "date_of_birth"
    t.integer "age"
    t.boolean "is_paid", default: false
    t.string "company_name"
    t.string "country"
    t.string "fcm_device_token"
    t.string "inspector_code"
    t.boolean "terms_and_conditions"
    t.string "subscription"
    t.string "device_type"
    t.integer "total_ads", default: 3
    t.bigint "temp_car_ad_id"
    t.string "temporary_token"
  end

  create_table "achievements", force: :cascade do |t|
    t.string "title"
    t.date "achievement_date"
    t.text "detail"
    t.string "url"
    t.integer "profile_bio_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.boolean "default_image", default: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "country"
    t.float "latitude"
    t.float "longitude"
    t.string "address"
    t.integer "account_id"
    t.string "addressble_type"
    t.integer "address_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "flat_no"
    t.string "building_name"
    t.string "street_address"
    t.string "post_box"
    t.string "city"
    t.string "state"
  end

  create_table "admin_email_notifications", force: :cascade do |t|
    t.integer "notification_name"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "advertisements", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "app_reviews", force: :cascade do |t|
    t.bigint "account_id"
    t.text "description"
    t.integer "rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_app_reviews_on_account_id"
  end

  create_table "application_message_translations", force: :cascade do |t|
    t.bigint "application_message_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "message", null: false
    t.index ["application_message_id"], name: "index_4df4694a81c904bef7786f2b09342fde44adca5f"
    t.index ["locale"], name: "index_application_message_translations_on_locale"
  end

  create_table "application_messages", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "associated_projects", force: :cascade do |t|
    t.integer "project_id"
    t.integer "associated_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "associateds", force: :cascade do |t|
    t.string "associated_with_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "attachments", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "colour"
    t.string "layout"
    t.string "page_size"
    t.string "scale"
    t.string "print_sides"
    t.integer "print_pages_from"
    t.integer "print_pages_to"
    t.integer "total_pages"
    t.boolean "is_expired", default: false
    t.integer "total_attachment_pages"
    t.string "pdf_url"
    t.boolean "is_printed", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_attachments_on_account_id"
  end

  create_table "audio_podcasts", force: :cascade do |t|
    t.string "heading"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "audios", force: :cascade do |t|
    t.integer "attached_item_id"
    t.string "attached_item_type"
    t.string "audio"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attached_item_id"], name: "index_audios_on_attached_item_id"
    t.index ["attached_item_type"], name: "index_audios_on_attached_item_type"
  end

  create_table "authors", force: :cascade do |t|
    t.string "name"
    t.text "bio"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "availabilities", force: :cascade do |t|
    t.bigint "service_provider_id"
    t.string "start_time"
    t.string "end_time"
    t.string "unavailable_start_time"
    t.string "unavailable_end_time"
    t.string "availability_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "timeslots"
    t.integer "available_slots_count"
    t.index ["service_provider_id"], name: "index_availabilities_on_service_provider_id"
  end

  create_table "awards", force: :cascade do |t|
    t.string "title"
    t.string "associated_with"
    t.string "issuer"
    t.datetime "issue_date"
    t.text "description"
    t.boolean "make_public", default: false, null: false
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "badges", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "badges_car_ads", id: false, force: :cascade do |t|
    t.bigint "car_ad_id", null: false
    t.bigint "badge_id", null: false
    t.index ["badge_id", "car_ad_id"], name: "index_badges_car_ads_on_badge_id_and_car_ad_id"
    t.index ["car_ad_id", "badge_id"], name: "index_badges_car_ads_on_car_ad_id_and_badge_id"
  end

  create_table "bank_details", force: :cascade do |t|
    t.string "fze_bank_name"
    t.string "emirates_nbd_swift"
    t.string "euro_account_name"
    t.string "account_no"
    t.string "iban"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "banners", force: :cascade do |t|
    t.integer "priority"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "black_list_users", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_black_list_users_on_account_id"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "content_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_bookmarks_on_account_id"
    t.index ["content_id"], name: "index_bookmarks_on_content_id"
  end

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_appointment_management_booked_slots", force: :cascade do |t|
    t.bigint "order_id"
    t.string "start_time"
    t.string "end_time"
    t.bigint "service_provider_id"
    t.date "booking_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_mixpanel_integration_mixpanel_integrations", force: :cascade do |t|
    t.integer "project_count"
    t.integer "account_count"
    t.integer "post_count"
    t.integer "car_ads_count"
    t.integer "award_count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "car_ads", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.integer "make_year"
    t.integer "mileage"
    t.text "more_details"
    t.string "regional_spec"
    t.integer "steering_side"
    t.string "body_color"
    t.integer "transmission"
    t.bigint "price"
    t.integer "status", default: 0
    t.bigint "account_id"
    t.bigint "admin_user_id"
    t.bigint "trim_id", null: false
    t.string "order_id"
    t.string "otp"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "ad_type", default: 0
    t.string "kms"
    t.string "mobile_number"
    t.integer "car_type", default: 0
    t.bigint "user_subscription_id"
    t.integer "horse_power"
    t.integer "no_of_cylinder"
    t.integer "battery_capacity"
    t.integer "no_of_doors"
    t.integer "warranty", default: 0
    t.string "body_type"
    t.integer "fuel_type", default: 0
    t.string "fuel_type_description"
    t.boolean "is_inspected", default: false
    t.index ["account_id"], name: "index_car_ads_on_account_id"
    t.index ["admin_user_id"], name: "index_car_ads_on_admin_user_id"
    t.index ["city_id"], name: "index_car_ads_on_city_id"
    t.index ["trim_id"], name: "index_car_ads_on_trim_id"
    t.index ["user_subscription_id"], name: "index_car_ads_on_user_subscription_id"
  end

  create_table "car_ads_colors", id: false, force: :cascade do |t|
    t.bigint "car_ad_id", null: false
    t.bigint "color_id", null: false
    t.index ["car_ad_id", "color_id"], name: "index_car_ads_colors_on_car_ad_id_and_color_id"
    t.index ["color_id", "car_ad_id"], name: "index_car_ads_colors_on_color_id_and_car_ad_id"
  end

  create_table "car_ads_engine_types", id: false, force: :cascade do |t|
    t.bigint "car_ad_id", null: false
    t.bigint "car_engine_type_id", null: false
    t.index ["car_ad_id", "car_engine_type_id"], name: "idx_car_ad_id_engine_type"
    t.index ["car_engine_type_id", "car_ad_id"], name: "idx_engine_type_id_car_ad_id"
  end

  create_table "car_ads_extras", id: false, force: :cascade do |t|
    t.bigint "car_ad_id", null: false
    t.bigint "extra_id", null: false
    t.index ["car_ad_id", "extra_id"], name: "index_car_ads_extras_on_car_ad_id_and_extra_id"
    t.index ["extra_id", "car_ad_id"], name: "index_car_ads_extras_on_extra_id_and_car_ad_id"
  end

  create_table "car_ads_features", id: false, force: :cascade do |t|
    t.bigint "car_ad_id", null: false
    t.bigint "feature_id", null: false
    t.index ["car_ad_id", "feature_id"], name: "index_car_ads_features_on_car_ad_id_and_feature_id"
    t.index ["feature_id", "car_ad_id"], name: "index_car_ads_features_on_feature_id_and_car_ad_id"
  end

  create_table "car_ads_regional_specs", id: false, force: :cascade do |t|
    t.bigint "car_ad_id", null: false
    t.bigint "regional_spec_id", null: false
    t.index ["car_ad_id", "regional_spec_id"], name: "index_car_ads_regional_specs_on_car_ad_id_and_regional_spec_id"
    t.index ["regional_spec_id", "car_ad_id"], name: "index_car_ads_regional_specs_on_regional_spec_id_and_car_ad_id"
  end

  create_table "car_ads_seller_types", id: false, force: :cascade do |t|
    t.bigint "car_ad_id", null: false
    t.bigint "seller_type_id", null: false
    t.index ["car_ad_id", "seller_type_id"], name: "idx_car_ad_id_seller_type_id"
    t.index ["seller_type_id", "car_ad_id"], name: "idx_seller_type_id_car_ad_id"
  end

  create_table "car_engine_types", force: :cascade do |t|
    t.string "name"
    t.string "engine_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "car_engine_types_models", id: false, force: :cascade do |t|
    t.bigint "model_id", null: false
    t.bigint "car_engine_type_id", null: false
    t.index ["car_engine_type_id", "model_id"], name: "idx_engine_type_id_model_id"
    t.index ["model_id", "car_engine_type_id"], name: "idx_model_engine_type"
  end

  create_table "car_fuel_types_models", id: false, force: :cascade do |t|
    t.bigint "model_id", null: false
    t.bigint "car_fuel_type_id", null: false
    t.index ["car_fuel_type_id", "model_id"], name: "index_car_fuel_types_models_on_car_fuel_type_id_and_model_id"
    t.index ["model_id", "car_fuel_type_id"], name: "index_car_fuel_types_models_on_model_id_and_car_fuel_type_id"
  end

  create_table "car_orders", force: :cascade do |t|
    t.string "order_request_id"
    t.string "continent"
    t.string "country"
    t.string "state"
    t.string "area"
    t.string "country_code"
    t.string "phone_number"
    t.string "full_phone_number"
    t.integer "account_id"
    t.integer "car_ad_id"
    t.integer "status"
    t.string "final_sale_amount"
    t.datetime "status_updated_at"
    t.integer "final_invoice_payment_status"
    t.text "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "vehicle_inspection_id"
    t.float "instant_deposit_amount"
    t.integer "instant_deposit_status"
    t.datetime "instant_deposit_paid_at"
    t.datetime "final_invoice_paid_at"
    t.datetime "cancelled_at"
    t.index ["vehicle_inspection_id"], name: "index_car_orders_on_vehicle_inspection_id"
  end

  create_table "career_experience_employment_types", force: :cascade do |t|
    t.integer "career_experience_id"
    t.integer "employment_type_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "career_experience_industry", force: :cascade do |t|
    t.integer "career_experience_id"
    t.integer "industry_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "career_experience_system_experiences", force: :cascade do |t|
    t.integer "career_experience_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "system_experience_id"
  end

  create_table "career_experiences", force: :cascade do |t|
    t.string "job_title"
    t.date "start_date"
    t.date "end_date"
    t.string "company_name"
    t.text "description"
    t.string "add_key_achievements"
    t.boolean "make_key_achievements_public", default: false, null: false
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "current_salary", default: "0.0"
    t.text "notice_period"
    t.date "notice_period_end_date"
    t.boolean "currently_working_here", default: false
  end

  create_table "careers", force: :cascade do |t|
    t.string "profession"
    t.boolean "is_current", default: false
    t.string "experience_from"
    t.string "experience_to"
    t.string "payscale"
    t.string "company_name"
    t.string "accomplishment", array: true
    t.integer "sector"
    t.integer "profile_bio_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "catalogue_reviews", force: :cascade do |t|
    t.bigint "catalogue_id", null: false
    t.string "comment"
    t.integer "rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["catalogue_id"], name: "index_catalogue_reviews_on_catalogue_id"
  end

  create_table "catalogue_variant_colors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "catalogue_variant_sizes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "catalogue_variants", force: :cascade do |t|
    t.bigint "catalogue_id", null: false
    t.bigint "catalogue_variant_color_id"
    t.bigint "catalogue_variant_size_id"
    t.decimal "price"
    t.integer "stock_qty"
    t.boolean "on_sale"
    t.decimal "sale_price"
    t.decimal "discount_price"
    t.float "length"
    t.float "breadth"
    t.float "height"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "block_qty"
    t.index ["catalogue_id"], name: "index_catalogue_variants_on_catalogue_id"
    t.index ["catalogue_variant_color_id"], name: "index_catalogue_variants_on_catalogue_variant_color_id"
    t.index ["catalogue_variant_size_id"], name: "index_catalogue_variants_on_catalogue_variant_size_id"
  end

  create_table "catalogues", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "sub_category_id", null: false
    t.bigint "brand_id"
    t.string "name"
    t.string "sku"
    t.string "description"
    t.datetime "manufacture_date"
    t.float "length"
    t.float "breadth"
    t.float "height"
    t.integer "availability"
    t.integer "stock_qty"
    t.decimal "weight"
    t.float "price"
    t.boolean "recommended"
    t.boolean "on_sale"
    t.decimal "sale_price"
    t.decimal "discount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "block_qty"
    t.index ["brand_id"], name: "index_catalogues_on_brand_id"
    t.index ["category_id"], name: "index_catalogues_on_category_id"
    t.index ["sub_category_id"], name: "index_catalogues_on_sub_category_id"
  end

  create_table "catalogues_tags", force: :cascade do |t|
    t.bigint "catalogue_id", null: false
    t.bigint "tag_id", null: false
    t.index ["catalogue_id"], name: "index_catalogues_tags_on_catalogue_id"
    t.index ["tag_id"], name: "index_catalogues_tags_on_tag_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "admin_user_id"
    t.integer "rank"
    t.string "light_icon"
    t.string "light_icon_active"
    t.string "light_icon_inactive"
    t.string "dark_icon"
    t.string "dark_icon_active"
    t.string "dark_icon_inactive"
    t.integer "identifier"
    t.boolean "optional"
  end

  create_table "categories_sub_categories", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "sub_category_id", null: false
    t.index ["category_id"], name: "index_categories_sub_categories_on_category_id"
    t.index ["sub_category_id"], name: "index_categories_sub_categories_on_sub_category_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.bigint "state_id", null: false
    t.string "zipcode"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["state_id"], name: "index_cities_on_state_id"
  end

  create_table "colors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contact_us", force: :cascade do |t|
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email"
    t.string "name"
  end

  create_table "content_texts", force: :cascade do |t|
    t.string "headline"
    t.string "content"
    t.string "hyperlink"
    t.string "affiliation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "content_types", force: :cascade do |t|
    t.string "name"
    t.integer "type"
    t.integer "identifier"
    t.integer "rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "content_videos", force: :cascade do |t|
    t.string "separate_section"
    t.string "headline"
    t.string "description"
    t.string "thumbnails"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contents", force: :cascade do |t|
    t.integer "sub_category_id"
    t.integer "category_id"
    t.integer "content_type_id"
    t.integer "language_id"
    t.integer "status"
    t.datetime "publish_date"
    t.boolean "archived", default: false
    t.boolean "feature_article"
    t.boolean "feature_video"
    t.string "searchable_text"
    t.integer "review_status"
    t.string "feedback"
    t.integer "admin_user_id"
    t.bigint "view_count", default: 0
    t.string "contentable_type"
    t.bigint "contentable_id"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_id"], name: "index_contents_on_author_id"
    t.index ["contentable_type", "contentable_id"], name: "index_contents_on_contentable_type_and_contentable_id"
  end

  create_table "contents_languages", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "language_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_contents_languages_on_account_id"
    t.index ["language_id"], name: "index_contents_languages_on_language_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.bigint "region_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "country_code"
    t.integer "phone_no_digit"
    t.index ["region_id"], name: "index_countries_on_region_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "course_name"
    t.string "duration"
    t.string "year"
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "credit_cards", force: :cascade do |t|
    t.string "digits"
    t.integer "month"
    t.integer "year"
    t.string "stripe_card_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "account_id"
    t.integer "status"
  end

  create_table "cta", force: :cascade do |t|
    t.string "headline"
    t.text "description"
    t.bigint "category_id"
    t.string "long_background_image"
    t.string "square_background_image"
    t.string "button_text"
    t.string "redirect_url"
    t.integer "text_alignment"
    t.integer "button_alignment"
    t.boolean "is_square_cta"
    t.boolean "is_long_rectangle_cta"
    t.boolean "is_text_cta"
    t.boolean "is_image_cta"
    t.boolean "has_button"
    t.boolean "visible_on_home_page"
    t.boolean "visible_on_details_page"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_cta_on_category_id"
  end

  create_table "current_annual_salaries", force: :cascade do |t|
    t.string "current_annual_salary"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "current_annual_salary_current_status", force: :cascade do |t|
    t.integer "current_status_id"
    t.integer "current_annual_salary_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "current_status", force: :cascade do |t|
    t.string "most_recent_job_title"
    t.string "company_name"
    t.text "notice_period"
    t.date "end_date"
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "current_status_employment_types", force: :cascade do |t|
    t.integer "current_status_id"
    t.integer "employment_type_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "current_status_industries", force: :cascade do |t|
    t.integer "current_status_id"
    t.integer "industry_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "dashboards", force: :cascade do |t|
    t.string "title"
    t.integer "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "degree_educational_qualifications", force: :cascade do |t|
    t.integer "educational_qualification_id"
    t.integer "degree_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "degrees", force: :cascade do |t|
    t.string "degree_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "destination_handlings", force: :cascade do |t|
    t.string "source_country"
    t.string "destination_country"
    t.string "unloading"
    t.string "customs_clearance"
    t.string "storage"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "documentation_charges", force: :cascade do |t|
    t.string "country"
    t.string "region"
    t.string "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "educational_qualification_field_study", force: :cascade do |t|
    t.integer "educational_qualification_id"
    t.integer "field_study_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "educational_qualifications", force: :cascade do |t|
    t.string "school_name"
    t.date "start_date"
    t.date "end_date"
    t.string "grades"
    t.text "description"
    t.boolean "make_grades_public", default: false, null: false
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "educations", force: :cascade do |t|
    t.string "qualification"
    t.integer "profile_bio_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "year_from"
    t.string "year_to"
    t.text "description"
  end

  create_table "email_notifications", force: :cascade do |t|
    t.bigint "notification_id", null: false
    t.string "send_to_email"
    t.datetime "sent_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["notification_id"], name: "index_email_notifications_on_notification_id"
  end

  create_table "email_otps", force: :cascade do |t|
    t.string "email"
    t.integer "pin"
    t.boolean "activated", default: false, null: false
    t.datetime "valid_until"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "employment_types", force: :cascade do |t|
    t.string "employment_type_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "epubs", force: :cascade do |t|
    t.string "heading"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "exams", force: :cascade do |t|
    t.string "heading"
    t.text "description"
    t.date "to"
    t.date "from"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "extras", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "favourites", force: :cascade do |t|
    t.integer "favourite_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "favouriteable_id"
    t.string "favouriteable_type"
  end

  create_table "features", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "field_study", force: :cascade do |t|
    t.string "field_of_study"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "flash_screens", force: :cascade do |t|
    t.integer "screen_type"
    t.string "title"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "offer"
    t.text "tips_for_advertisment_posting"
    t.string "offer_title"
    t.string "tips_title"
    t.string "description_title"
  end

  create_table "follows", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "content_provider_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_follows_on_account_id"
    t.index ["content_provider_id"], name: "index_follows_on_content_provider_id"
  end

  create_table "global_offices", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "address_line_1"
    t.text "address_line_2"
    t.bigint "city_id", default: 1, null: false
    t.index ["city_id"], name: "index_global_offices_on_city_id"
  end

  create_table "global_settings", force: :cascade do |t|
    t.string "notice_period"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "hobbies_and_interests", force: :cascade do |t|
    t.string "title"
    t.string "category"
    t.text "description"
    t.boolean "make_public", default: false, null: false
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "images", force: :cascade do |t|
    t.integer "attached_item_id"
    t.string "attached_item_type"
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "item_type"
    t.index ["attached_item_id"], name: "index_images_on_attached_item_id"
    t.index ["attached_item_type"], name: "index_images_on_attached_item_type"
  end

  create_table "industries", force: :cascade do |t|
    t.string "industry_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "inspection_charges", force: :cascade do |t|
    t.string "country"
    t.string "region"
    t.string "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "inspection_reports", force: :cascade do |t|
    t.string "google_drive_url"
    t.bigint "vehicle_inspection_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["vehicle_inspection_id"], name: "index_inspection_reports_on_vehicle_inspection_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "language"
    t.string "proficiency"
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer "like_by_id"
    t.string "likeable_type", null: false
    t.bigint "likeable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable_type_and_likeable_id"
  end

  create_table "live_streams", force: :cascade do |t|
    t.string "headline"
    t.string "description"
    t.string "comment_section"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "locations", force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.integer "van_id"
    t.text "address"
    t.string "locationable_type", null: false
    t.bigint "locationable_id", null: false
    t.index ["locationable_type", "locationable_id"], name: "index_locations_on_locationable_type_and_locationable_id"
  end

  create_table "models", force: :cascade do |t|
    t.string "name"
    t.string "body_type"
    t.string "engine_type"
    t.boolean "autopilot"
    t.integer "autopilot_type"
    t.bigint "company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_models_on_company_id"
  end

  create_table "models_transmission_types", id: false, force: :cascade do |t|
    t.bigint "model_id", null: false
    t.bigint "transmission_type_id", null: false
    t.index ["model_id", "transmission_type_id"], name: "idx_model_transmission_type"
    t.index ["transmission_type_id", "model_id"], name: "idx_transmission_type_id_model_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "created_by"
    t.string "headings"
    t.string "contents"
    t.string "app_url"
    t.boolean "is_read", default: false
    t.datetime "read_at"
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_notifications_on_account_id"
  end

  create_table "payment_transactions", force: :cascade do |t|
    t.bigint "account_id"
    t.string "target_type"
    t.integer "target_id"
    t.string "transaction_id", null: false
    t.integer "status"
    t.jsonb "payload"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_payment_transactions_on_account_id"
    t.index ["target_type", "target_id"], name: "index_payment_transactions_on_target_type_and_target_id"
  end

  create_table "pdfs", force: :cascade do |t|
    t.integer "attached_item_id"
    t.string "attached_item_type"
    t.string "pdf"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attached_item_id"], name: "index_pdfs_on_attached_item_id"
    t.index ["attached_item_type"], name: "index_pdfs_on_attached_item_type"
  end

  create_table "photo_libraries", force: :cascade do |t|
    t.string "photo"
    t.string "caption"
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_photo_libraries_on_account_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.integer "duration"
    t.float "price"
    t.text "details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "ad_count"
  end

  create_table "ports", force: :cascade do |t|
    t.string "port_name"
    t.bigint "country_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["country_id"], name: "index_ports_on_country_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.bigint "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "body"
    t.string "location"
    t.integer "account_id"
    t.index ["category_id"], name: "index_posts_on_category_id"
  end

  create_table "preferences", force: :cascade do |t|
    t.integer "seeking"
    t.string "discover_people", array: true
    t.text "location"
    t.integer "distance"
    t.integer "height_type"
    t.integer "body_type"
    t.integer "religion"
    t.integer "smoking"
    t.integer "drinking"
    t.integer "profile_bio_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "friend", default: false
    t.boolean "business", default: false
    t.boolean "match_making", default: false
    t.boolean "travel_partner", default: false
    t.boolean "cross_path", default: false
    t.integer "age_range_start"
    t.integer "age_range_end"
    t.string "height_range_start"
    t.string "height_range_end"
    t.integer "account_id"
  end

  create_table "profile_bios", force: :cascade do |t|
    t.integer "account_id"
    t.string "height"
    t.string "weight"
    t.integer "height_type"
    t.integer "weight_type"
    t.integer "body_type"
    t.integer "mother_tougue"
    t.integer "religion"
    t.integer "zodiac"
    t.integer "marital_status"
    t.string "languages", array: true
    t.text "about_me"
    t.string "personality", array: true
    t.string "interests", array: true
    t.integer "smoking"
    t.integer "drinking"
    t.integer "looking_for"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "about_business"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "country"
    t.string "address"
    t.string "postal_code"
    t.integer "account_id"
    t.string "photo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "profile_role"
    t.string "city"
  end

  create_table "projects", force: :cascade do |t|
    t.string "project_name"
    t.date "start_date"
    t.date "end_date"
    t.string "add_members"
    t.string "url"
    t.text "description"
    t.boolean "make_projects_public", default: false, null: false
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "publication_patents", force: :cascade do |t|
    t.string "title"
    t.string "publication"
    t.string "authors"
    t.string "url"
    t.text "description"
    t.boolean "make_public", default: false, null: false
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "push_notifications", force: :cascade do |t|
    t.bigint "account_id"
    t.string "push_notificable_type", null: false
    t.bigint "push_notificable_id", null: false
    t.string "remarks"
    t.boolean "is_read", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "notify_type"
    t.integer "created_by"
    t.string "logo"
    t.string "notification_type"
    t.string "notification_type_id"
    t.boolean "completion_check", default: false
    t.boolean "is_inspected", default: false
    t.string "random_key"
    t.index ["account_id"], name: "index_push_notifications_on_account_id"
    t.index ["push_notificable_type", "push_notificable_id"], name: "index_push_notification_type_and_id"
  end

  create_table "regional_specs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "phone_no_digit"
  end

  create_table "requests", force: :cascade do |t|
    t.integer "account_id"
    t.integer "sender_id"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reviews_reviews", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.integer "account_id"
    t.integer "reviewer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "anonymous", default: false
    t.integer "rating"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "seller_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "service_shippings", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "services", force: :cascade do |t|
    t.string "logo"
    t.string "title"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "shipment_user_reviews", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "shipment_id"
    t.text "review"
    t.integer "quick_response_rating"
    t.integer "detailed_service_rating"
    t.integer "supportive_rating"
    t.index ["account_id"], name: "index_shipment_user_reviews_on_account_id"
    t.index ["shipment_id"], name: "index_shipment_user_reviews_on_shipment_id"
  end

  create_table "shipments", force: :cascade do |t|
    t.date "estimated_time_of_departure"
    t.date "estimated_time_of_arrival"
    t.string "shipping_line"
    t.string "container_number"
    t.string "bl_number"
    t.string "tracking_link"
    t.integer "car_order_id"
    t.string "payment_link"
    t.text "review"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "account_id"
    t.integer "status"
    t.integer "delivery_status"
    t.float "destination_cost"
    t.integer "payment_mode"
    t.integer "payment_status"
    t.string "stripe_payment_link_id"
    t.integer "payment_link_active"
    t.integer "vehicle_shipping_id"
  end

  create_table "shipping_charges", force: :cascade do |t|
    t.string "destination_country"
    t.string "destination_port"
    t.string "price"
    t.string "in_transit"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "source_country"
  end

  create_table "sms_otps", force: :cascade do |t|
    t.string "full_phone_number"
    t.integer "pin"
    t.boolean "activated", default: false, null: false
    t.datetime "valid_until"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.bigint "country_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["country_id"], name: "index_states_on_country_id"
  end

  create_table "stripe_products", force: :cascade do |t|
    t.string "name", null: false
    t.string "product_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "parent_id"
    t.integer "rank"
  end

  create_table "system_experiences", force: :cascade do |t|
    t.string "system_experience"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "terms_and_conditions", force: :cascade do |t|
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "test_score_and_courses", force: :cascade do |t|
    t.string "title"
    t.string "associated_with"
    t.string "score"
    t.datetime "test_date"
    t.text "description"
    t.boolean "make_public", default: false, null: false
    t.integer "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tests", force: :cascade do |t|
    t.text "description"
    t.string "headline"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string "order_id"
    t.string "razorpay_order_id"
    t.string "razorpay_payment_id"
    t.string "razorpay_signature"
    t.integer "account_id"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "trims", force: :cascade do |t|
    t.string "name"
    t.bigint "model_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["model_id"], name: "index_trims_on_model_id"
  end

  create_table "user_categories", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_user_categories_on_account_id"
    t.index ["category_id"], name: "index_user_categories_on_category_id"
  end

  create_table "user_sub_categories", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "sub_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_user_sub_categories_on_account_id"
    t.index ["sub_category_id"], name: "index_user_sub_categories_on_sub_category_id"
  end

  create_table "user_subscriptions", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "plan_id", null: false
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "start_date"
    t.date "expiry_date"
    t.index ["account_id"], name: "index_user_subscriptions_on_account_id"
    t.index ["plan_id"], name: "index_user_subscriptions_on_plan_id"
  end

  create_table "van_members", force: :cascade do |t|
    t.integer "account_id"
    t.integer "van_id"
  end

  create_table "vans", force: :cascade do |t|
    t.string "name"
    t.text "bio"
    t.boolean "is_offline"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "vehicle_inspections", force: :cascade do |t|
    t.bigint "city_id"
    t.bigint "model_id"
    t.bigint "account_id"
    t.bigint "admin_user_id"
    t.integer "make_year"
    t.text "about"
    t.string "price"
    t.string "vin_number"
    t.string "seller_name"
    t.string "seller_mobile_number"
    t.string "seller_email"
    t.float "inspection_amount"
    t.text "notes_for_the_inspector"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0
    t.integer "car_ad_id"
    t.integer "inspector_id"
    t.integer "acceptance_status"
    t.text "instant_deposit_link"
    t.text "notes_for_the_admin"
    t.string "final_sale_amount"
    t.date "inspection_scheduled_on"
    t.integer "instant_deposit_status", default: 0
    t.integer "final_invoice_status", default: 0
    t.float "instant_deposit_amount"
    t.string "stripe_payment_link_id"
    t.integer "payment_link_active"
    t.string "seller_country_code"
    t.string "advertisement_url"
    t.string "regional_spec"
    t.string "car_ad_type"
    t.datetime "status_updated_at"
    t.index ["account_id"], name: "index_vehicle_inspections_on_account_id"
    t.index ["admin_user_id"], name: "index_vehicle_inspections_on_admin_user_id"
    t.index ["city_id"], name: "index_vehicle_inspections_on_city_id"
    t.index ["model_id"], name: "index_vehicle_inspections_on_model_id"
    t.index ["seller_email"], name: "index_vehicle_inspections_on_seller_email"
    t.index ["seller_mobile_number"], name: "index_vehicle_inspections_on_seller_mobile_number"
  end

  create_table "vehicle_orders", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "vehicle_selling_id"
    t.string "order_request_id"
    t.string "continent"
    t.string "country"
    t.string "state"
    t.string "area"
    t.string "country_code"
    t.string "phone_number"
    t.string "full_phone_number"
    t.integer "status"
    t.string "final_sale_amount"
    t.datetime "status_updated_at"
    t.boolean "final_invoice_payment_status"
    t.text "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "instant_deposit_amount"
    t.integer "instant_deposit_status"
    t.integer "vehicle_selling_inspection_id"
    t.integer "vehicle_shipping_id"
    t.bigint "car_ad_id"
    t.bigint "vehicle_inspection_id"
    t.boolean "payment_check", default: false
    t.index ["account_id"], name: "index_vehicle_orders_on_account_id"
    t.index ["vehicle_selling_id"], name: "index_vehicle_orders_on_vehicle_selling_id"
  end

  create_table "vehicle_payments", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "transaction_id"
    t.string "status"
    t.integer "amount"
    t.datetime "date"
    t.bigint "vehicle_selling_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "car_ad_id"
    t.index ["account_id"], name: "index_vehicle_payments_on_account_id"
    t.index ["car_ad_id"], name: "index_vehicle_payments_on_car_ad_id"
    t.index ["vehicle_selling_id"], name: "index_vehicle_payments_on_vehicle_selling_id"
  end

  create_table "vehicle_selling_inspections", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.bigint "account_id"
    t.bigint "admin_user_id"
    t.integer "make_year"
    t.text "about"
    t.float "price"
    t.string "vin_numbers"
    t.string "seller_name"
    t.string "seller_mobile_number"
    t.string "seller_email"
    t.float "inspection_amount"
    t.text "notes_for_the_inspector"
    t.integer "status", default: 0
    t.integer "vehicle_selling_id"
    t.integer "inspector_id"
    t.integer "acceptance_status"
    t.text "instant_deposit_link"
    t.text "notes_for_the_admin"
    t.float "final_sale_amount"
    t.date "inspection_scheduled_on"
    t.integer "instant_deposit_status", default: 0
    t.integer "final_invoice_status", default: 0
    t.float "instant_deposit_amount"
    t.string "stripe_payment_link_id"
    t.integer "payment_link_active"
    t.string "seller_country_code"
    t.string "advertisement_url"
    t.string "regional_spec"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "model"
    t.index ["account_id"], name: "index_vehicle_selling_inspections_on_account_id"
    t.index ["admin_user_id"], name: "index_vehicle_selling_inspections_on_admin_user_id"
    t.index ["city_id"], name: "index_vehicle_selling_inspections_on_city_id"
  end

  create_table "vehicle_sellings", force: :cascade do |t|
    t.bigint "city_id"
    t.bigint "account_id"
    t.bigint "trim_id"
    t.bigint "region_id"
    t.bigint "country_id"
    t.bigint "state_id"
    t.integer "year"
    t.string "model"
    t.string "regional_spec"
    t.string "kms"
    t.string "body_type"
    t.string "body_color"
    t.string "seller_type"
    t.string "engine_type"
    t.string "steering_side"
    t.string "badges"
    t.string "features"
    t.string "make"
    t.integer "no_of_doors"
    t.integer "warranty"
    t.integer "no_of_cylinder"
    t.float "horse_power"
    t.string "contact_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "verified", default: false
    t.string "transmission"
    t.string "price"
    t.text "about_car"
    t.string "status", default: "listed"
    t.string "tracking_number"
    t.integer "tracking_status", default: 0
    t.boolean "is_inspected", default: false
    t.boolean "approved_by_admin", default: false
    t.index ["account_id"], name: "index_vehicle_sellings_on_account_id"
    t.index ["city_id"], name: "index_vehicle_sellings_on_city_id"
    t.index ["country_id"], name: "index_vehicle_sellings_on_country_id"
    t.index ["region_id"], name: "index_vehicle_sellings_on_region_id"
    t.index ["state_id"], name: "index_vehicle_sellings_on_state_id"
    t.index ["trim_id"], name: "index_vehicle_sellings_on_trim_id"
  end

  create_table "vehicle_shippings", force: :cascade do |t|
    t.string "region"
    t.string "country"
    t.string "state"
    t.string "area"
    t.integer "year"
    t.string "make"
    t.string "model"
    t.string "regional_specs"
    t.string "country_code"
    t.string "phone_number"
    t.string "full_phone_number"
    t.string "source_country"
    t.string "pickup_port"
    t.string "destination_country"
    t.string "destination_port"
    t.text "shipping_instruction"
    t.integer "account_id"
    t.integer "final_shipping_amount"
    t.integer "payment_confirmation_status"
    t.integer "status"
    t.datetime "estimated_time_of_departure"
    t.datetime "estimated_time_of_arrival"
    t.string "shipping_line"
    t.string "container_number"
    t.string "bl_number"
    t.string "tracking_link"
    t.integer "delivery_status"
    t.string "payment_link"
    t.text "review"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "order_request_id"
    t.datetime "order_confirmed_at"
    t.datetime "order_shipped_at"
    t.datetime "destination_reached_at"
    t.datetime "cancelled_at"
    t.datetime "delivered_at"
    t.string "final_destination_charge"
    t.string "transaction_id"
    t.datetime "transaction_date"
    t.string "payment_status", default: "pending"
    t.string "amount_paid"
    t.boolean "approved_by_admin", default: false
    t.boolean "vehicle_pickup", default: false
    t.boolean "order_placed", default: false
    t.string "other_charge"
    t.text "notes_for_admin"
    t.boolean "onboard", default: false
    t.boolean "shipment_noti", default: false
    t.boolean "arrived", default: false
    t.boolean "destination_service", default: false
    t.bigint "service_shippings_id"
    t.integer "payment_type"
    t.integer "invoice_amount"
    t.integer "shipping_status"
    t.string "tracking_number"
    t.datetime "picked_up_date"
    t.datetime "onboarded_date"
    t.datetime "arrived_date"
    t.datetime "delivered_date"
    t.index ["service_shippings_id"], name: "index_vehicle_shippings_on_service_shippings_id"
  end

  create_table "videos", force: :cascade do |t|
    t.integer "attached_item_id"
    t.string "attached_item_type"
    t.string "video"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attached_item_id"], name: "index_videos_on_attached_item_id"
    t.index ["attached_item_type"], name: "index_videos_on_attached_item_type"
  end

  create_table "view_profiles", force: :cascade do |t|
    t.integer "profile_bio_id"
    t.integer "view_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "account_id"
  end

  create_table "whats_app_numbers", force: :cascade do |t|
    t.string "whatsapp_number"
    t.string "country_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "app_reviews", "accounts"
  add_foreign_key "attachments", "accounts"
  add_foreign_key "black_list_users", "accounts"
  add_foreign_key "bookmarks", "accounts"
  add_foreign_key "bookmarks", "contents"
  add_foreign_key "car_ads", "accounts"
  add_foreign_key "car_ads", "admin_users"
  add_foreign_key "car_ads", "cities"
  add_foreign_key "car_ads", "trims"
  add_foreign_key "catalogue_reviews", "catalogues"
  add_foreign_key "catalogue_variants", "catalogue_variant_colors"
  add_foreign_key "catalogue_variants", "catalogue_variant_sizes"
  add_foreign_key "catalogue_variants", "catalogues"
  add_foreign_key "catalogues", "brands"
  add_foreign_key "catalogues", "categories"
  add_foreign_key "catalogues", "sub_categories"
  add_foreign_key "catalogues_tags", "catalogues"
  add_foreign_key "catalogues_tags", "tags"
  add_foreign_key "categories_sub_categories", "categories"
  add_foreign_key "categories_sub_categories", "sub_categories"
  add_foreign_key "cities", "states"
  add_foreign_key "contents", "authors"
  add_foreign_key "contents_languages", "accounts"
  add_foreign_key "contents_languages", "languages"
  add_foreign_key "countries", "regions"
  add_foreign_key "email_notifications", "notifications"
  add_foreign_key "follows", "accounts"
  add_foreign_key "global_offices", "cities"
  add_foreign_key "inspection_reports", "vehicle_inspections"
  add_foreign_key "models", "companies"
  add_foreign_key "notifications", "accounts"
  add_foreign_key "payment_transactions", "accounts"
  add_foreign_key "photo_libraries", "accounts"
  add_foreign_key "ports", "countries"
  add_foreign_key "posts", "categories"
  add_foreign_key "push_notifications", "accounts"
  add_foreign_key "states", "countries"
  add_foreign_key "taggings", "tags"
  add_foreign_key "trims", "models"
  add_foreign_key "user_categories", "accounts"
  add_foreign_key "user_categories", "categories"
  add_foreign_key "user_sub_categories", "accounts"
  add_foreign_key "user_sub_categories", "sub_categories"
  add_foreign_key "user_subscriptions", "accounts"
  add_foreign_key "user_subscriptions", "plans"
  add_foreign_key "vehicle_inspections", "accounts"
  add_foreign_key "vehicle_inspections", "admin_users"
  add_foreign_key "vehicle_inspections", "cities"
  add_foreign_key "vehicle_inspections", "models"
  add_foreign_key "vehicle_orders", "accounts"
  add_foreign_key "vehicle_orders", "vehicle_sellings"
  add_foreign_key "vehicle_payments", "accounts"
  add_foreign_key "vehicle_payments", "vehicle_sellings"
  add_foreign_key "vehicle_selling_inspections", "accounts"
  add_foreign_key "vehicle_selling_inspections", "admin_users"
  add_foreign_key "vehicle_selling_inspections", "cities"
  add_foreign_key "vehicle_sellings", "accounts"
  add_foreign_key "vehicle_sellings", "cities"
  add_foreign_key "vehicle_sellings", "countries"
  add_foreign_key "vehicle_sellings", "regions"
  add_foreign_key "vehicle_sellings", "states"
  add_foreign_key "vehicle_sellings", "trims"
  add_foreign_key "vehicle_shippings", "service_shippings", column: "service_shippings_id"
end
