class CreateProcedures < ActiveRecord::Migration[6.0]
  def change
    create_table :procedures do |t|
      t.string :description
      t.text :image_url
      t.text :image_key
      t.belongs_to :recipe
      t.timestamps
    end
  end
end
