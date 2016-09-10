# == Schema Information
#
# Table name: commission_reports
#
#  id                 :integer          not null, primary key
#  employee_name      :string
#  customer_name      :string
#  account_manager_id :integer
#  recruiter_id       :integer
#  support_id         :integer
#  pay_rate           :decimal(, )
#  total_hours        :decimal(, )
#  total_gross_pay    :decimal(, )
#  total_bill         :decimal(, )
#  am_rate            :decimal(, )
#  rec_rate           :decimal(, )
#  sup_rate           :decimal(, )
#  mark_up            :decimal(, )
#  week_ending        :date
#  week_beginning     :date
#  revenue            :decimal(, )
#  am_amount          :decimal(, )
#  rec_amount         :decimal(, )
#  sup_amount         :decimal(, )
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  start_date         :date
#  double             :boolean          default(FALSE)
#

require 'test_helper'

class CommissionReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
