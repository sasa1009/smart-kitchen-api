class CreateRecipes < ActiveRecord::Migration[6.0]
  def change
    create_table :recipes do |t|
      t.string :title
      t.string :comment
      t.integer :amount
      t.integer :calorie
      t.string :main_ingredient
      t.string :category
      t.string :tips
      t.text :image_url
      t.text :image_key
      t.timestamps
    end

    add_index :recipes, :title
    add_index :recipes, :main_ingredient
    add_index :recipes, :category
  end
end
