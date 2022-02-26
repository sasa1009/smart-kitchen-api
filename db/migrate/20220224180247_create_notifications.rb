class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :recipe, foreign_key: true
      t.references :sender, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
