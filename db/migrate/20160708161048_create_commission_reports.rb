class CreateCommissionReports < ActiveRecord::Migration
  def change
    create_table :commission_reports do |t|
      t.string :employee_name
      t.string :customer_name
      t.integer :account_manager_id
      t.integer :recruiter_id
      t.integer :support_id
      t.decimal :pay_rate
      t.decimal :total_hours
      t.decimal :total_gross_pay
      t.decimal :total_bill
      t.decimal :am_rate
      t.decimal :rec_rate
      t.decimal :sup_rate
      t.decimal :mark_up
      t.date :week_ending
      t.date :week_beginning
      t.decimal :revenue
      t.decimal :am_amount
      t.decimal :rec_amount
      t.decimal :sup_amount

      t.timestamps null: false
    end
    add_index :commission_reports, :account_manager_id
    add_index :commission_reports, :recruiter_id
    add_index :commission_reports, :support_id
  end
end
