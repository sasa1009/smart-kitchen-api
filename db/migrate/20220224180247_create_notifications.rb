class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.belongs_to :user, foreign_key: true
      t.bigint :sender_id
      t.bigint :recipe_id

      t.timestamps
    end
  end
end
