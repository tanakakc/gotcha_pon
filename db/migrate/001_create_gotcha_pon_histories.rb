# frozen_string_literal: true

class CreateGotchaPonHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :gotcha_pon_histories do |t|
      t.references :user, polymorphic: true, null: false, index: true
      t.references :gotchable, polymorphic: true, null: false, index: true
      t.datetime :executed_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.json :metadata, default: {}

      t.timestamps

      t.index [:user_type, :user_id, :created_at]
      t.index [:gotchable_type, :gotchable_id]
    end
  end
end