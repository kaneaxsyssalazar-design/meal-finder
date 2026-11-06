class CreateMealTags < ActiveRecord::Migration[8.1]
  def change
    create_table :meal_tags do |t|
      t.references :meal, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
