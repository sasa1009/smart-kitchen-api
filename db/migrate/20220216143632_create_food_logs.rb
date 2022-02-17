class CreateFoodLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :food_logs do |t|
      t.string :name
      t.integer :calorie
      t.integer :amount
      t.bigint :recipe_id
      t.datetime :meal_date_time
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
