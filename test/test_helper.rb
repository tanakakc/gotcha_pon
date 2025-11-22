# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "gacha_pon"
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
end

class TestItem < ActiveRecord::Base
  include GachaPon::Ponnable
end
