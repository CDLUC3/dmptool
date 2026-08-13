# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_30_232821) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", precision: nil, null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "current_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "last_sign_in_at", precision: nil
    t.string "last_sign_in_ip"
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0
    t.datetime "updated_at", precision: nil
  end

  create_table "annotations", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "org_id"
    t.integer "question_id"
    t.text "text"
    t.integer "type", default: 0, null: false
    t.datetime "updated_at", precision: nil
    t.string "versionable_id", limit: 36
    t.index ["org_id"], name: "fk_rails_aca7521f72"
    t.index ["question_id"], name: "index_annotations_on_question_id"
    t.index ["versionable_id"], name: "index_annotations_on_versionable_id"
  end

  create_table "answers", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "lock_version", default: 0
    t.integer "plan_id"
    t.integer "question_id"
    t.text "text"
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
    t.index ["plan_id"], name: "fk_rails_84a6005a3e"
    t.index ["plan_id"], name: "index_answers_on_plan_id"
    t.index ["question_id"], name: "fk_rails_3d5ed4418f"
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["user_id"], name: "fk_rails_584be190c2"
  end

  create_table "answers_options", id: false, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "answer_id", null: false
    t.integer "option_id", null: false
    t.index ["answer_id", "option_id"], name: "index_answers_options_on_answer_id_and_option_id"
  end

  create_table "answers_question_options", id: false, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "answer_id", null: false
    t.integer "question_option_id", null: false
    t.index ["answer_id"], name: "index_answers_question_options_on_answer_id"
  end

  create_table "api_clients", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "callback_method"
    t.string "callback_uri"
    t.string "client_id", null: false
    t.string "client_secret", null: false
    t.boolean "confidential", default: true
    t.string "contact_email"
    t.string "contact_name"
    t.datetime "created_at", precision: nil, null: false
    t.string "description"
    t.string "homepage"
    t.datetime "last_access", precision: nil
    t.string "name", null: false
    t.integer "org_id"
    t.text "redirect_uri"
    t.string "scopes", default: "", null: false
    t.boolean "trusted", default: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_oauth_applications_on_name"
  end

  create_table "api_logs", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.text "activity"
    t.bigint "api_client_id", null: false
    t.integer "change_type", null: false
    t.datetime "created_at", precision: nil, null: false
    t.bigint "logable_id"
    t.string "logable_type"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["api_client_id"], name: "index_api_logs_on_api_client_id"
    t.index ["change_type"], name: "index_api_logs_on_change_type"
    t.index ["logable_id", "logable_type", "change_type"], name: "index_api_logs_on_logable_and_change_type"
  end

  create_table "conditions", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "action_type"
    t.datetime "created_at", precision: nil, null: false
    t.integer "number"
    t.text "option_list"
    t.integer "question_id"
    t.text "remove_data"
    t.datetime "updated_at", precision: nil, null: false
    t.text "webhook_data"
    t.index ["question_id"], name: "index_conditions_on_question_id"
  end

  create_table "contributors", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "email"
    t.string "name"
    t.integer "org_id"
    t.string "phone"
    t.integer "plan_id", null: false
    t.integer "roles", null: false
    t.datetime "updated_at", precision: nil
    t.index ["email"], name: "index_contributors_on_email"
    t.index ["name", "id", "org_id"], name: "index_contrib_id_and_org_id"
    t.index ["org_id"], name: "index_contributors_on_org_id"
    t.index ["plan_id"], name: "index_contributors_on_plan_id"
    t.index ["roles"], name: "index_contributors_on_roles"
  end

  create_table "delayed_jobs", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "attempts", default: 0, null: false
    t.datetime "created_at"
    t.datetime "failed_at", precision: nil
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "locked_at", precision: nil
    t.string "locked_by"
    t.integer "priority", default: 0, null: false
    t.string "queue"
    t.datetime "run_at", precision: nil
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "departments", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", precision: nil, null: false
    t.string "name"
    t.integer "org_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["org_id"], name: "index_departments_on_org_id"
  end

  create_table "dmptemplates", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.text "description"
    t.boolean "is_default"
    t.string "locale"
    t.integer "organisation_id"
    t.boolean "published"
    t.string "title"
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
  end

  create_table "drafts", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "dmp_id"
    t.string "draft_id"
    t.json "metadata", null: false
    t.string "publisher_job_status", default: "success"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["draft_id"], name: "index_drafts_on_draft_id"
  end

  create_table "exported_plans", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "format"
    t.integer "phase_id"
    t.integer "plan_id"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id"
  end

  create_table "external_api_access_tokens", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "access_token", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "expires_at", precision: nil
    t.string "external_service_name", null: false
    t.string "refresh_token"
    t.datetime "revoked_at", precision: nil
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id", null: false
    t.index ["expires_at"], name: "index_external_api_access_tokens_on_expires_at"
    t.index ["external_service_name"], name: "index_external_api_access_tokens_on_external_service_name"
    t.index ["user_id", "external_service_name"], name: "index_external_tokens_on_user_and_service"
    t.index ["user_id"], name: "index_external_api_access_tokens_on_user_id"
  end

  create_table "file_types", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "icon_location"
    t.string "icon_name"
    t.integer "icon_size"
    t.string "name"
    t.datetime "updated_at", precision: nil
  end

  create_table "file_uploads", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.text "description"
    t.integer "file_type_id"
    t.string "location"
    t.string "name"
    t.boolean "published"
    t.integer "size"
    t.string "title"
    t.datetime "updated_at", precision: nil
  end

  create_table "friendly_id_slugs", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 40
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", unique: true
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "guidance_groups", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "name"
    t.boolean "optional_subset", default: false, null: false
    t.integer "org_id"
    t.boolean "published", default: false, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["org_id"], name: "index_guidance_groups_on_org_id"
  end

  create_table "guidance_in_group", id: false, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "guidance_group_id", null: false
    t.integer "guidance_id", null: false
    t.index ["guidance_id", "guidance_group_id"], name: "index_guidance_in_group_on_guidance_id_and_guidance_group_id"
  end

  create_table "guidances", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "guidance_group_id"
    t.boolean "published"
    t.text "text"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["guidance_group_id"], name: "index_guidances_on_guidance_group_id"
  end

  create_table "hidden_dmps", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "dmp_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["dmp_id", "user_id"], name: "index_hidden_dmps_on_dmp_id_and_user_id", unique: true
    t.index ["dmp_id"], name: "index_hidden_dmps_on_dmp_id"
    t.index ["user_id"], name: "index_hidden_dmps_on_user_id"
  end

  create_table "identifier_schemes", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.boolean "active"
    t.integer "context"
    t.datetime "created_at", precision: nil
    t.string "description"
    t.string "external_service"
    t.string "identifier_prefix"
    t.string "logo_url"
    t.string "name"
    t.datetime "updated_at", precision: nil
  end

  create_table "identifiers", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.text "attrs"
    t.datetime "created_at", precision: nil
    t.integer "identifiable_id"
    t.string "identifiable_type"
    t.integer "identifier_scheme_id"
    t.datetime "updated_at", precision: nil
    t.string "value", null: false
    t.index ["identifiable_type", "identifiable_id"], name: "index_identifiers_on_identifiable_type_and_identifiable_id"
    t.index ["identifier_scheme_id", "identifiable_id", "identifiable_type"], name: "index_identifiers_on_scheme_and_type_and_id"
    t.index ["identifier_scheme_id", "value"], name: "index_identifiers_on_identifier_scheme_id_and_value"
  end

  create_table "languages", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "abbreviation"
    t.boolean "default_language"
    t.string "description"
    t.string "name"
  end

  create_table "licenses", charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.boolean "deprecated", default: false
    t.string "identifier", null: false
    t.string "name", null: false
    t.boolean "osi_approved", default: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "uri"
    t.index ["identifier", "osi_approved", "deprecated"], name: "index_license_on_identifier_and_criteria"
    t.index ["identifier"], name: "index_licenses_on_identifier"
    t.index ["uri"], name: "index_licenses_on_uri"
  end

  create_table "metadata_standards", charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.text "description"
    t.json "locations"
    t.string "rdamsc_id"
    t.json "related_entities"
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
    t.string "uri"
  end

  create_table "metadata_standards_research_outputs", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "metadata_standard_id"
    t.bigint "research_output_id"
    t.index ["metadata_standard_id"], name: "metadata_research_outputs_on_metadata"
    t.index ["research_output_id"], name: "metadata_research_outputs_on_ro"
  end

  create_table "notes", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "answer_id"
    t.boolean "archived", default: false, null: false
    t.integer "archived_by"
    t.datetime "created_at", precision: nil
    t.text "text"
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
    t.index ["answer_id"], name: "index_notes_on_answer_id"
    t.index ["user_id"], name: "fk_rails_7f2323ad43"
  end

  create_table "notification_acknowledgements", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "notification_id"
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
    t.index ["notification_id"], name: "index_notification_acknowledgements_on_notification_id"
    t.index ["user_id"], name: "index_notification_acknowledgements_on_user_id"
  end

  create_table "notifications", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", precision: nil, null: false
    t.boolean "dismissable"
    t.boolean "enabled", default: true
    t.date "expires_at"
    t.integer "level"
    t.integer "notification_type"
    t.date "starts_at"
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "oauth_access_grants", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "application_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.integer "resource_owner_id", null: false
    t.datetime "revoked_at", precision: nil
    t.string "scopes", default: "", null: false
    t.string "token", null: false
    t.index ["application_id"], name: "fk_rails_b4b53e07b8"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "application_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.integer "expires_in"
    t.string "previous_refresh_token", default: "", null: false
    t.string "refresh_token"
    t.integer "resource_owner_id"
    t.datetime "revoked_at", precision: nil
    t.string "scopes"
    t.string "token", null: false
    t.index ["application_id"], name: "fk_rails_732cb83ab7"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "callback_method", default: 0
    t.string "callback_uri"
    t.boolean "confidential", default: true
    t.string "contact_email"
    t.string "contact_name"
    t.datetime "created_at", precision: nil, null: false
    t.string "description"
    t.string "homepage"
    t.datetime "last_access", precision: nil
    t.string "logo_name"
    t.string "logo_uid"
    t.string "name", null: false
    t.integer "org_id"
    t.text "redirect_uri"
    t.string "scopes", default: "", null: false
    t.string "secret", default: "", null: false
    t.boolean "trusted", default: false
    t.string "uid", default: "", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.index ["name"], name: "index_oauth_applications_on_name"
    t.index ["user_id"], name: "index_oauth_applications_on_owner_id"
    t.index ["user_id"], name: "index_oauth_applications_on_owner_id_and_owner_type"
  end

  create_table "option_warnings", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "option_id"
    t.integer "organisation_id"
    t.text "text"
    t.datetime "updated_at", precision: nil
  end

  create_table "options", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.boolean "is_default"
    t.integer "number"
    t.integer "question_id"
    t.string "text"
    t.datetime "updated_at", precision: nil
  end

  create_table "org_token_permissions", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "org_id"
    t.integer "token_permission_type_id"
    t.datetime "updated_at", precision: nil
    t.index ["org_id"], name: "index_org_token_permissions_on_org_id"
    t.index ["token_permission_type_id"], name: "fk_rails_2aa265f538"
  end

  create_table "organisation_types", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.text "description"
    t.string "name"
    t.datetime "updated_at", precision: nil
  end

  create_table "organisations", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "abbreviation"
    t.integer "banner_file_id"
    t.datetime "created_at", precision: nil
    t.text "description"
    t.string "domain"
    t.boolean "is_other"
    t.integer "logo_file_id"
    t.string "name"
    t.integer "organisation_type_id"
    t.integer "parent_id"
    t.integer "stylesheet_file_id"
    t.string "target_url"
    t.datetime "updated_at", precision: nil
    t.integer "wayfless_entity"
  end

  create_table "orgs", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "abbreviation"
    t.text "api_create_plan_email_body"
    t.string "api_create_plan_email_subject"
    t.string "contact_email"
    t.string "contact_name"
    t.datetime "created_at", precision: nil, null: false
    t.boolean "feedback_enabled", default: false
    t.text "feedback_msg"
    t.string "helpdesk_email"
    t.boolean "is_other", default: false, null: false
    t.integer "language_id"
    t.text "links"
    t.string "logo_name"
    t.string "logo_uid"
    t.boolean "managed", default: false, null: false
    t.string "name"
    t.integer "org_type", default: 0, null: false
    t.integer "region_id"
    t.string "target_url"
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "v5_pilot", default: false
    t.index ["language_id"], name: "fk_rails_5640112cab"
    t.index ["region_id"], name: "fk_rails_5a6adf6bab"
  end

  create_table "pages", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.text "body_text"
    t.datetime "created_at", precision: nil
    t.string "location"
    t.integer "menu"
    t.integer "menu_position"
    t.integer "organisation_id"
    t.boolean "public"
    t.string "slug"
    t.string "target_url"
    t.string "title"
    t.datetime "updated_at", precision: nil
  end

  create_table "perms", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "name"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "phases", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.text "description"
    t.boolean "modifiable"
    t.integer "number"
    t.integer "template_id"
    t.string "title"
    t.datetime "updated_at", precision: nil
    t.string "versionable_id", limit: 36
    t.index ["template_id"], name: "index_phases_on_template_id"
    t.index ["versionable_id"], name: "index_phases_on_versionable_id"
  end

  create_table "plan_sections", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "plan_id"
    t.datetime "release_time", precision: nil
    t.integer "section_id"
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
  end

  create_table "plans", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.boolean "accept_terms", default: false
    t.boolean "complete", default: false
    t.datetime "created_at", precision: nil
    t.string "data_contact"
    t.string "data_contact_email"
    t.string "data_contact_phone"
    t.text "description"
    t.string "dmp_id"
    t.datetime "end_date", precision: nil
    t.boolean "ethical_issues"
    t.text "ethical_issues_description"
    t.string "ethical_issues_report"
    t.boolean "featured", default: false
    t.datetime "feedback_end_at", precision: nil
    t.boolean "feedback_requested", default: false
    t.datetime "feedback_start_at", precision: nil
    t.integer "funder_id"
    t.string "funder_name"
    t.integer "funding_status"
    t.integer "grant_id"
    t.string "grant_number"
    t.string "identifier"
    t.bigint "language_id"
    t.string "narrative_url"
    t.integer "org_id"
    t.string "principal_investigator"
    t.string "principal_investigator_email"
    t.string "principal_investigator_identifier"
    t.string "principal_investigator_phone"
    t.string "publisher_job_status", default: "success"
    t.bigint "research_domain_id"
    t.datetime "start_date", precision: nil
    t.string "subscriber_job_status", default: "success"
    t.integer "template_id"
    t.string "title"
    t.datetime "updated_at", precision: nil
    t.integer "visibility", default: 3, null: false
    t.index ["funder_id"], name: "index_plans_on_funder_id"
    t.index ["grant_id"], name: "index_plans_on_grant_id"
    t.index ["language_id"], name: "index_plans_on_language_id"
    t.index ["org_id"], name: "index_plans_on_org_id"
    t.index ["research_domain_id"], name: "index_plans_on_research_domain_id"
    t.index ["template_id"], name: "index_plans_on_template_id"
  end

  create_table "plans_guidance_groups", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "guidance_group_id"
    t.integer "plan_id"
    t.index ["guidance_group_id", "plan_id"], name: "index_plans_guidance_groups_on_guidance_group_id_and_plan_id"
    t.index ["guidance_group_id"], name: "fk_rails_ec1c5524d7"
    t.index ["plan_id"], name: "fk_rails_13d0671430"
  end

  create_table "prefs", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.text "settings"
    t.integer "user_id"
  end

  create_table "project_groups", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.boolean "project_administrator"
    t.boolean "project_creator"
    t.boolean "project_editor"
    t.integer "project_id"
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
  end

  create_table "project_guidance", id: false, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "guidance_group_id", null: false
    t.integer "project_id", null: false
    t.index ["project_id", "guidance_group_id"], name: "index_project_guidance_on_project_id_and_guidance_group_id"
  end

  create_table "projects", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "data_contact"
    t.string "description"
    t.integer "dmptemplate_id"
    t.string "grant_number"
    t.string "identifier"
    t.boolean "locked"
    t.text "note"
    t.integer "organisation_id"
    t.string "principal_investigator"
    t.string "principal_investigator_identifier"
    t.string "slug"
    t.string "title"
    t.datetime "updated_at", precision: nil
    t.index ["slug"], name: "index_projects_on_slug", unique: true
  end

  create_table "question_format_labels", id: false, charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "description"
    t.integer "id"
    t.integer "number"
    t.integer "question_id"
    t.datetime "updated_at", precision: nil
  end

  create_table "question_formats", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.text "description"
    t.integer "formattype", default: 0
    t.boolean "option_based", default: false
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "question_options", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.boolean "is_default"
    t.integer "number"
    t.integer "question_id"
    t.string "text"
    t.datetime "updated_at", precision: nil
    t.string "versionable_id", limit: 36
    t.index ["question_id"], name: "index_question_options_on_question_id"
    t.index ["versionable_id"], name: "index_question_options_on_versionable_id"
  end

  create_table "questions", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.text "default_value"
    t.boolean "modifiable"
    t.integer "number"
    t.boolean "option_comment_display", default: true
    t.integer "question_format_id"
    t.integer "section_id"
    t.text "text"
    t.datetime "updated_at", precision: nil
    t.string "versionable_id", limit: 36
    t.index ["question_format_id"], name: "fk_rails_4fbc38c8c7"
    t.index ["section_id"], name: "index_questions_on_section_id"
    t.index ["versionable_id"], name: "index_questions_on_versionable_id"
  end

  create_table "questions_themes", id: false, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "question_id", null: false
    t.integer "theme_id", null: false
    t.index ["question_id"], name: "index_questions_themes_on_question_id"
  end

  create_table "regions", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "abbreviation"
    t.string "description"
    t.string "name"
    t.integer "super_region_id"
  end

  create_table "registry_orgs", charset: "utf8mb3", force: :cascade do |t|
    t.json "acronyms"
    t.json "aliases"
    t.string "api_auth_target"
    t.text "api_guidance"
    t.json "api_query_fields"
    t.string "api_target"
    t.json "country"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "file_timestamp", precision: nil
    t.string "fundref_id"
    t.string "home_page"
    t.string "language"
    t.string "name"
    t.bigint "org_id"
    t.string "ror_id"
    t.json "types"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["file_timestamp"], name: "index_registry_orgs_on_file_timestamp"
    t.index ["fundref_id"], name: "index_registry_orgs_on_fundref_id"
    t.index ["name"], name: "index_registry_orgs_on_name"
    t.index ["org_id"], name: "index_registry_orgs_on_org_id"
    t.index ["ror_id"], name: "index_registry_orgs_on_ror_id"
  end

  create_table "related_identifiers", charset: "utf8mb3", force: :cascade do |t|
    t.text "citation"
    t.datetime "created_at", precision: nil, null: false
    t.bigint "identifiable_id"
    t.string "identifiable_type"
    t.bigint "identifier_scheme_id"
    t.integer "identifier_type", null: false
    t.integer "relation_type", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "value", null: false
    t.integer "work_type", default: 0
    t.index ["identifiable_id", "identifiable_type", "relation_type"], name: "index_relateds_on_identifiable_and_relation_type"
    t.index ["identifier_scheme_id"], name: "index_related_identifiers_on_identifier_scheme_id"
    t.index ["identifier_type"], name: "index_related_identifiers_on_identifier_type"
    t.index ["relation_type"], name: "index_related_identifiers_on_relation_type"
  end

  create_table "repositories", charset: "utf8mb3", force: :cascade do |t|
    t.string "contact"
    t.datetime "created_at", precision: nil, null: false
    t.text "description", null: false
    t.string "homepage"
    t.json "info"
    t.string "name", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "uri", null: false
    t.index ["homepage"], name: "index_repositories_on_homepage"
    t.index ["name"], name: "index_repositories_on_name"
  end

  create_table "repositories_research_outputs", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "repository_id"
    t.bigint "research_output_id"
    t.index ["repository_id"], name: "index_repositories_research_outputs_on_repository_id"
    t.index ["research_output_id"], name: "index_repositories_research_outputs_on_research_output_id"
  end

  create_table "research_domains", charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "identifier", null: false
    t.string "label", null: false
    t.bigint "parent_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["parent_id"], name: "index_research_domains_on_parent_id"
  end

  create_table "research_outputs", charset: "utf8mb3", force: :cascade do |t|
    t.string "abbreviation"
    t.integer "access", default: 0, null: false
    t.bigint "byte_size"
    t.datetime "created_at", precision: nil, null: false
    t.text "description"
    t.integer "display_order"
    t.boolean "is_default"
    t.bigint "license_id"
    t.boolean "personal_data"
    t.integer "plan_id"
    t.datetime "release_date", precision: nil
    t.string "research_output_type", default: "dataset", null: false
    t.boolean "sensitive_data"
    t.string "title", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["license_id"], name: "index_research_outputs_on_license_id"
    t.index ["plan_id"], name: "index_research_outputs_on_plan_id"
  end

  create_table "roles", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "access", default: 0, null: false
    t.boolean "active", default: true
    t.datetime "created_at", precision: nil
    t.integer "plan_id"
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
    t.index ["plan_id"], name: "index_roles_on_plan_id"
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "sections", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.text "description"
    t.boolean "modifiable"
    t.integer "number"
    t.integer "phase_id"
    t.string "title"
    t.datetime "updated_at", precision: nil
    t.string "versionable_id", limit: 36
    t.index ["phase_id"], name: "index_sections_on_phase_id"
    t.index ["versionable_id"], name: "index_sections_on_versionable_id"
  end

  create_table "sessions", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.text "data"
    t.string "session_id", limit: 64, null: false
    t.datetime "updated_at", precision: nil
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "settings", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "target_id", null: false
    t.string "target_type"
    t.datetime "updated_at", precision: nil, null: false
    t.text "value"
    t.string "var"
    t.index ["target_id", "target_type"], name: "settings_target"
  end

  create_table "stats", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.bigint "count", default: 0
    t.datetime "created_at", precision: nil, null: false
    t.date "date", null: false
    t.text "details"
    t.boolean "filtered", default: false
    t.integer "org_id"
    t.string "type", null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "subscriptions", charset: "utf8mb3", force: :cascade do |t|
    t.string "callback_uri"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "last_notified", precision: nil
    t.bigint "plan_id"
    t.bigint "subscriber_id"
    t.string "subscriber_type"
    t.integer "subscription_types", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["plan_id"], name: "index_subscriptions_on_plan_id"
    t.index ["subscriber_id", "subscriber_type", "plan_id"], name: "index_subscribers_on_identifiable_and_plan_id"
  end

  create_table "suggested_answers", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "organisation_id"
    t.integer "question_id"
    t.text "text"
    t.datetime "updated_at", precision: nil
  end

  create_table "template_licenses", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "license_id"
    t.integer "template_id"
    t.index ["license_id"], name: "index_template_licenses_on_license_id"
    t.index ["template_id"], name: "index_template_licenses_on_template_id"
  end

  create_table "template_metadata_standards", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "metadata_standard_id"
    t.integer "template_id"
    t.index ["metadata_standard_id"], name: "index_template_metadata_standards_on_metadata_standard_id"
    t.index ["template_id"], name: "index_template_metadata_standards_on_template_id"
  end

  create_table "template_output_types", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "research_output_type"
    t.bigint "template_id"
    t.index ["template_id"], name: "index_template_output_types_on_template_id"
  end

  create_table "template_repositories", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "repository_id"
    t.integer "template_id"
    t.index ["repository_id"], name: "index_template_repositories_on_repository_id"
    t.index ["template_id"], name: "index_template_repositories_on_template_id"
  end

  create_table "templates", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.boolean "archived"
    t.datetime "created_at", precision: nil
    t.integer "customization_of"
    t.boolean "customize_licenses", default: false
    t.boolean "customize_metadata_standards", default: false
    t.boolean "customize_output_types", default: false
    t.boolean "customize_repositories", default: false
    t.text "description"
    t.text "email_body"
    t.string "email_subject"
    t.boolean "enable_research_outputs", default: true
    t.integer "family_id"
    t.boolean "is_default"
    t.text "links"
    t.string "locale"
    t.integer "org_id"
    t.boolean "published"
    t.string "publisher_job_status", default: "success"
    t.integer "sponsor_id"
    t.string "title"
    t.datetime "updated_at", precision: nil
    t.text "user_guidance_licenses"
    t.text "user_guidance_metadata_standards"
    t.text "user_guidance_output_types"
    t.text "user_guidance_repositories"
    t.integer "version"
    t.integer "visibility"
    t.index ["family_id", "version"], name: "index_templates_on_family_id_and_version", unique: true
    t.index ["family_id"], name: "index_templates_on_family_id"
    t.index ["org_id", "family_id"], name: "template_organisation_dmptemplate_index"
    t.index ["org_id"], name: "index_templates_on_org_id"
  end

  create_table "themes", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.text "description"
    t.string "locale"
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "themes_in_guidance", id: false, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "guidance_id"
    t.integer "theme_id"
    t.index ["guidance_id"], name: "index_themes_in_guidance_on_guidance_id"
    t.index ["theme_id"], name: "index_themes_in_guidance_on_theme_id"
  end

  create_table "token_permission_types", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.text "text_description"
    t.string "token_type"
    t.datetime "updated_at", precision: nil
  end

  create_table "trackers", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", precision: nil, null: false
    t.integer "org_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["org_id"], name: "index_trackers_on_org_id"
  end

  create_table "user_org_roles", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "organisation_id"
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
    t.integer "user_role_type_id"
  end

  create_table "user_role_types", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.text "description"
    t.string "name"
    t.datetime "updated_at", precision: nil
  end

  create_table "user_statuses", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.text "description"
    t.string "name"
    t.datetime "updated_at", precision: nil
  end

  create_table "user_types", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.text "description"
    t.string "name"
    t.datetime "updated_at", precision: nil
  end

  create_table "users", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.boolean "accept_terms"
    t.boolean "active", default: true
    t.string "api_token"
    t.datetime "confirmation_sent_at", precision: nil
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.integer "department_id"
    t.string "email", limit: 80, default: "", null: false
    t.string "encrypted_password"
    t.string "firstname"
    t.datetime "invitation_accepted_at", precision: nil
    t.datetime "invitation_created_at", precision: nil
    t.integer "invitation_plan_id"
    t.datetime "invitation_sent_at", precision: nil
    t.string "invitation_token"
    t.integer "invited_by_id"
    t.string "invited_by_type"
    t.integer "language_id"
    t.datetime "last_api_access", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "last_sign_in_ip"
    t.string "ldap_password"
    t.string "ldap_username"
    t.integer "org_id"
    t.string "other_organisation"
    t.string "recovery_email"
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0
    t.string "surname"
    t.string "ui_token"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["department_id"], name: "fk_rails_f29bf9cdf2"
    t.index ["email"], name: "index_users_on_email"
    t.index ["language_id"], name: "fk_rails_45f4f12508"
    t.index ["org_id"], name: "index_users_on_org_id"
  end

  create_table "users_perms", id: false, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "perm_id"
    t.integer "user_id"
    t.index ["perm_id"], name: "fk_rails_457217c31c"
    t.index ["user_id"], name: "index_users_perms_on_user_id"
  end

  create_table "users_roles", id: false, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
  end

  create_table "versions", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.text "description"
    t.integer "number"
    t.integer "phase_id"
    t.integer "published"
    t.boolean "published_tmp"
    t.string "title"
    t.datetime "updated_at", precision: nil
    t.index ["phase_id"], name: "index_versions_on_phase_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "annotations", "orgs"
  add_foreign_key "annotations", "questions"
  add_foreign_key "answers", "plans"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users"
  add_foreign_key "conditions", "questions"
  add_foreign_key "guidance_groups", "orgs"
  add_foreign_key "guidances", "guidance_groups"
  add_foreign_key "notes", "answers"
  add_foreign_key "notes", "users"
  add_foreign_key "notification_acknowledgements", "notifications"
  add_foreign_key "notification_acknowledgements", "users"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_grants", "users", column: "resource_owner_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
  add_foreign_key "org_token_permissions", "orgs"
  add_foreign_key "org_token_permissions", "token_permission_types"
  add_foreign_key "orgs", "languages"
  add_foreign_key "orgs", "regions"
  add_foreign_key "phases", "templates"
  add_foreign_key "plans", "orgs"
  add_foreign_key "plans", "templates"
  add_foreign_key "plans_guidance_groups", "guidance_groups"
  add_foreign_key "plans_guidance_groups", "plans"
  add_foreign_key "question_options", "questions"
  add_foreign_key "questions", "question_formats"
  add_foreign_key "questions", "sections"
  add_foreign_key "research_domains", "research_domains", column: "parent_id"
  add_foreign_key "roles", "plans"
  add_foreign_key "roles", "users"
  add_foreign_key "sections", "phases"
  add_foreign_key "template_licenses", "licenses"
  add_foreign_key "template_licenses", "templates"
  add_foreign_key "template_metadata_standards", "metadata_standards"
  add_foreign_key "template_metadata_standards", "templates"
  add_foreign_key "template_repositories", "repositories"
  add_foreign_key "template_repositories", "templates"
  add_foreign_key "templates", "orgs"
  add_foreign_key "themes_in_guidance", "guidances"
  add_foreign_key "themes_in_guidance", "themes"
  add_foreign_key "trackers", "orgs"
  add_foreign_key "users", "departments"
  add_foreign_key "users", "languages"
  add_foreign_key "users", "orgs"
end
