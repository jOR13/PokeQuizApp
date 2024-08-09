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

ActiveRecord::Schema[7.1].define(version: 2024_08_09_064339) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "player_quizzes", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "quiz_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_player_quizzes_on_player_id"
    t.index ["quiz_id"], name: "index_player_quizzes_on_quiz_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_players_on_name", unique: true
  end

  create_table "quizzes", force: :cascade do |t|
    t.jsonb "content", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "level"
    t.boolean "ai_mode", default: false, null: false
    t.integer "score"
  end

  add_foreign_key "player_quizzes", "players"
  add_foreign_key "player_quizzes", "quizzes"
end
