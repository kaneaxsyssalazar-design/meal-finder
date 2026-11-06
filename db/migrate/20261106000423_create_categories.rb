class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.string :thumbnail_url
      t.string :external_id

      t.timestamps
    end
  end
end
