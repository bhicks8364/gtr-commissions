class MainController < ApplicationController
  def index
    if user_signed_in?
      @chart_reports = CommissionReport.includes(:account_manager, :recruiter, :support, :customer).distinct if current_user.admin?
      @chart_reports = current_user.reports if !current_user.admin?
      @q = @chart_reports.ransack(params[:q])
      @commission_reports = @q.result(distinct: true)
    end
  end
end
