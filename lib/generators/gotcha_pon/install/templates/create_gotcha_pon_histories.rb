class CreateGotchaPonHistories < ActiveRecord::Migration[<%= ActiveRecord::Migration.current_version %>]
  def change
    create_table :gotcha_pon_histories do |t|
      t.references :user, polymorphic: true, null: true, index: true
      t.references :gotchable, polymorphic: true, null: false, index: true
      t.datetime :executed_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.json :metadata, default: {}
      t.timestamps
      
      t.index [:user_type, :user_id]
      t.index [:gotchable_type, :gotchable_id]
      t.index :executed_at
    end
  end
end