class AddColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_set_weight_loss_target, :boolean
    add_column :users, :height, :integer
    add_column :users, :weight, :integer
    add_column :users, :sex, :string
    add_column :users, :age, :integer
    add_column :users, :activity_amount, :float
    add_column :users, :weight_loss_target, :float
  end
end
