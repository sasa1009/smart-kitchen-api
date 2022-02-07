class AddImageKeyToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :image_key, :text
  end
end
