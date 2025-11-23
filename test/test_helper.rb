# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "gotcha_pon"
require "minitest/autorun"
require "active_record"

# Setup in-memory SQLite database for testing
ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:"
)

ActiveRecord::Schema.define do
  create_table :test_items do |t|
    t.string :name
    t.string :rarity
    t.integer :weight
    t.timestamps
  end
  
  create_table :gotcha_pon_histories do |t|
    t.references :user, polymorphic: true, null: false, index: true
    t.references :gotchable, polymorphic: true, null: false, index: true
    t.datetime :executed_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    t.json :metadata, default: {}
    t.timestamps
  end
end

class TestItem < ActiveRecord::Base
  include GotchaPon::Gotchable
end
