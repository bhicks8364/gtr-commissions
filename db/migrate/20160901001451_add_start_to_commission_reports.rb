class AddStartToCommissionReports < ActiveRecord::Migration
  def change
    add_column :commission_reports, :start_date, :date
  end
end
