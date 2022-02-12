class Createfavorites < ActiveRecord::Migration[6.0]
  def change
    create_table :favorites do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :recipe, foreign_key: true
      t.timestamps
    end
    add_index :favorites, [:user_id, :recipe_id], unique: true
  end
end
