class CreateFoodLogTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :food_log_templates do |t|
      t.string :name
      t.integer :calorie
      t.bigint :recipe_id
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
