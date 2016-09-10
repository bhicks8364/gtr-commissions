class AddCustomerIdToCommissionReports < ActiveRecord::Migration
  def change
    add_column :commission_reports, :customer_id, :integer
    add_index :commission_reports, :customer_id
  end
end
