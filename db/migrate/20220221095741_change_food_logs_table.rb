class ChangeFoodLogsTable < ActiveRecord::Migration[6.0]
  def change
    change_column :food_logs, :amount, :float
  end
end
