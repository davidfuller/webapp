# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130228140034) do

  create_table "aspects", :force => true do |t|
    t.string   "name"
    t.integer  "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_suffix"
  end

  create_table "bugs", :force => true do |t|
    t.string   "name"
    t.integer  "page_number"
    t.integer  "channel_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "channels", :force => true do |t|
    t.string   "name"
    t.string   "press_code"
    t.string   "playlist_code"
    t.integer  "language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "domain"
    t.string   "path"
    t.string   "bss_name"
    t.boolean  "hd"
    t.string   "prefix"
    t.string   "logo_filename"
    t.boolean  "circle_logo"
    t.string   "encoding"
    t.boolean  "has_dynamic_branding"
  end

  create_table "commons", :force => true do |t|
    t.string   "english"
    t.string   "danish"
    t.string   "swedish"
    t.string   "norwegian"
    t.string   "hungarian"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comparisons", :force => true do |t|
    t.datetime "start"
    t.datetime "rounded"
    t.string   "long_title"
    t.string   "house_no"
    t.datetime "press_start"
    t.string   "original_title"
    t.string   "danish_title"
    t.boolean  "contained"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "found_house"
    t.boolean  "found_title"
    t.integer  "channel_id"
  end

  create_table "countdown_ipps", :force => true do |t|
    t.string   "name"
    t.integer  "channel_id"
    t.datetime "first_use"
    t.datetime "last_use"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countdown_ipps_media_files", :id => false, :force => true do |t|
    t.integer  "countdown_ipp_id"
    t.integer  "media_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cross_channel_priorities", :force => true do |t|
    t.datetime "billed"
    t.string   "original_title"
    t.string   "local_title"
    t.string   "lead_text"
    t.integer  "channel_id"
    t.integer  "tx_channel_id"
    t.integer  "press_id"
    t.integer  "title_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dynamic_specials", :force => true do |t|
    t.string   "name"
    t.integer  "channel_id"
    t.integer  "page"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "houses", :force => true do |t|
    t.string   "house_number"
    t.integer  "title_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "series_number_id"
  end

  create_table "ignores", :force => true do |t|
    t.string   "word"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jpeg_folders", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jpegs", :force => true do |t|
    t.string   "name"
    t.string   "filename"
    t.integer  "jpeg_folder_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_files", :force => true do |t|
    t.string   "name"
    t.string   "filename"
    t.integer  "media_folder_id"
    t.datetime "first_use"
    t.datetime "last_use"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_id"
    t.integer  "media_type_id"
  end

  create_table "media_files_promos", :id => false, :force => true do |t|
    t.integer  "media_file_id"
    t.integer  "promo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_folders", :force => true do |t|
    t.string   "name"
    t.string   "folder"
    t.integer  "channel_id"
    t.boolean  "clip"
    t.boolean  "system"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "aspect_id"
  end

  create_table "media_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "playlist_filenames", :force => true do |t|
    t.string   "filename"
    t.date     "schedule_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "channel_id"
  end

  create_table "playlist_lines", :force => true do |t|
    t.integer  "event"
    t.datetime "start"
    t.time     "duration"
    t.string   "source"
    t.string   "material_type"
    t.string   "house_no"
    t.string   "title"
    t.string   "long_title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "rounded"
    t.integer  "part"
    t.time     "timecode"
    t.boolean  "full_programme"
    t.integer  "playlist_filename_id"
  end

  create_table "playlist_position_settings", :force => true do |t|
    t.string   "item"
    t.integer  "position"
    t.integer  "length"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "press_filenames", :force => true do |t|
    t.string   "filename"
    t.datetime "import_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "press_lines", :force => true do |t|
    t.datetime "start"
    t.string   "display_title"
    t.string   "original_title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "channel_id"
    t.integer  "press_filename_id"
    t.string   "lead_text"
    t.boolean  "priority"
  end

  create_table "press_tab_settings", :force => true do |t|
    t.string   "item"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "priorities", :force => true do |t|
    t.datetime "start"
    t.integer  "press_filename_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "promos", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "title_id"
    t.datetime "first_use"
    t.datetime "last_use"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedule_comparisons", :force => true do |t|
    t.datetime "start"
    t.string   "title"
    t.string   "house_number"
    t.string   "series_number"
    t.datetime "press_start"
    t.string   "original_title"
    t.string   "local_title"
    t.boolean  "contained"
    t.boolean  "found_house"
    t.boolean  "found_series"
    t.boolean  "found_title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "channel_id"
    t.integer  "schedule_file_id"
  end

  create_table "schedule_files", :force => true do |t|
    t.string   "name"
    t.integer  "channel_id"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedule_lines", :force => true do |t|
    t.datetime "start"
    t.string   "house_no"
    t.string   "title"
    t.string   "series_title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "series_number"
    t.integer  "schedule_file_id"
  end

  create_table "schedule_tab_settings", :force => true do |t|
    t.string   "item"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "deletion_rule"
  end

  create_table "series_numbers", :force => true do |t|
    t.string   "series_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "special_fields", :force => true do |t|
    t.integer  "number"
    t.string   "description"
    t.string   "default_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", :force => true do |t|
    t.integer  "value"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "titles", :force => true do |t|
    t.string   "english"
    t.string   "danish"
    t.string   "swedish"
    t.string   "norwegian"
    t.string   "hungarian"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "eop"
  end

  create_table "upload_playlist_files", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
