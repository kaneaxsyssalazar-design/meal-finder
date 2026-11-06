class CreateMeals < ActiveRecord::Migration[8.1]
  def change
    create_table :meals do |t|
      t.string :name
      t.text :instructions
      t.string :thumbnail_url
      t.string :youtube_url
      t.string :source_url
      t.string :external_id
      t.references :category, null: false, foreign_key: true
      t.references :area, null: false, foreign_key: true

      t.timestamps
    end
  end
end
