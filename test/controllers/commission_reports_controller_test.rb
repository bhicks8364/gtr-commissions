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

class CommissionReportsControllerTest < ActionController::TestCase
  setup do
    @commission_report = commission_reports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:commission_reports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create commission_report" do
    assert_difference('CommissionReport.count') do
      post :create, commission_report: { account_manager_id: @commission_report.account_manager_id, am_amount: @commission_report.am_amount, am_rate: @commission_report.am_rate, customer_name: @commission_report.customer_name, employee_name: @commission_report.employee_name, mark_up: @commission_report.mark_up, pay_rate: @commission_report.pay_rate, rec_amount: @commission_report.rec_amount, rec_rate: @commission_report.rec_rate, recruiter_id: @commission_report.recruiter_id, revenue: @commission_report.revenue, sup_amount: @commission_report.sup_amount, sup_rate: @commission_report.sup_rate, support_id: @commission_report.support_id, total_bill: @commission_report.total_bill, total_gross_pay: @commission_report.total_gross_pay, total_hours: @commission_report.total_hours, week_beginning: @commission_report.week_beginning, week_ending: @commission_report.week_ending }
    end

    assert_redirected_to commission_report_path(assigns(:commission_report))
  end

  test "should show commission_report" do
    get :show, id: @commission_report
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @commission_report
    assert_response :success
  end

  test "should update commission_report" do
    patch :update, id: @commission_report, commission_report: { account_manager_id: @commission_report.account_manager_id, am_amount: @commission_report.am_amount, am_rate: @commission_report.am_rate, customer_name: @commission_report.customer_name, employee_name: @commission_report.employee_name, mark_up: @commission_report.mark_up, pay_rate: @commission_report.pay_rate, rec_amount: @commission_report.rec_amount, rec_rate: @commission_report.rec_rate, recruiter_id: @commission_report.recruiter_id, revenue: @commission_report.revenue, sup_amount: @commission_report.sup_amount, sup_rate: @commission_report.sup_rate, support_id: @commission_report.support_id, total_bill: @commission_report.total_bill, total_gross_pay: @commission_report.total_gross_pay, total_hours: @commission_report.total_hours, week_beginning: @commission_report.week_beginning, week_ending: @commission_report.week_ending }
    assert_redirected_to commission_report_path(assigns(:commission_report))
  end

  test "should destroy commission_report" do
    assert_difference('CommissionReport.count', -1) do
      delete :destroy, id: @commission_report
    end

    assert_redirected_to commission_reports_path
  end
end
