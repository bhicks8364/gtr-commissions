class AddAdvancedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :advanced, :boolean, default: false
    add_column :users, :multi_rates, :boolean, default: false
    add_column :commission_reports, :double, :boolean, default: false
  end
end
