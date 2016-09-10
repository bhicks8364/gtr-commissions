json.array!(@commission_reports) do |commission_report|
  json.extract! commission_report, :id, :employee_name, :customer_name, :account_manager_id, :recruiter_id, :support_id, :pay_rate, :total_hours, :total_gross_pay, :total_bill, :am_rate, :rec_rate, :sup_rate, :mark_up, :week_ending, :week_beginning, :revenue, :am_amount, :rec_amount, :sup_amount
  json.url commission_report_url(commission_report, format: :json)
end
