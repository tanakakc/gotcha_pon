class CreateItems < ActiveRecord::Migration[8.1]
  def change
    create_table :items do |t|
      t.string :name
      t.string :rarity
      t.integer :weight

      t.timestamps
    end
  end
end
