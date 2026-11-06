class CreateIngredients < ActiveRecord::Migration[8.1]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.text :description
      t.string :ingredient_type
      t.string :external_id

      t.timestamps
    end
  end
end
