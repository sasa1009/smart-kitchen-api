class AddCommentToUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :nickname, :string
    remove_column :users, :image, :string
    add_column :users, :comment, :string
    add_column :users, :image_url, :string
  end
end
