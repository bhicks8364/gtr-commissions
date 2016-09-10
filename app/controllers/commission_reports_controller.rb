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

class CommissionReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commission_report, only: [:show, :edit, :update, :destroy]

  # GET /commission_reports
  # GET /commission_reports.json
  def index
    @import  = CommissionReport::Import.new
    @commission_reports = CommissionReport.all if current_user.admin?
    @commission_reports = current_user.reports if !current_user.admin?
    respond_to do |format|
      format.html
      format.csv { send_data @commission_reports.distinct.to_csv, filename: "#{current_user.name}-commissions-#{Time.current}.csv" }
    end 
  end

  # GET /commission_reports/1
  # GET /commission_reports/1.json
  def show
  end

  # GET /commission_reports/new
  def new
    @commission_report = CommissionReport.new
  end
  
  def import
    @import  = CommissionReport::Import.new(commission_report_import_params)
    if @import.save
      redirect_to commission_reports_path, notice: "Imported #{@import_count} commissions."
    else
      flash[:alert] = "There were errors with your CSV file."
      render action: :index
    end
  end
  

  # GET /commission_reports/1/edit
  def edit
  end

  # POST /commission_reports
  # POST /commission_reports.json
  def create
    @commission_report = CommissionReport.new(commission_report_params)

    respond_to do |format|
      if @commission_report.save
        format.html { redirect_to @commission_report, notice: 'Commission report was successfully created.' }
        format.json { render :show, status: :created, location: @commission_report }
      else
        format.html { render :new }
        format.json { render json: @commission_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /commission_reports/1
  # PATCH/PUT /commission_reports/1.json
  def update
    respond_to do |format|
      if @commission_report.update(commission_report_params)
        format.html { redirect_to @commission_report, notice: 'Commission report was successfully updated.' }
        format.json { render :show, status: :ok, location: @commission_report }
      else
        format.html { render :edit }
        format.json { render json: @commission_report.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def reset_all
    CommissionReport.all.map(&:destroy)
    redirect_to commission_reports_path, notice: "Successfully deleted all commission records."
  end
  
  # DELETE /commission_reports/1
  # DELETE /commission_reports/1.json
  def destroy
    @commission_report.destroy
    respond_to do |format|
      format.html { redirect_to commission_reports_url, notice: 'Commission report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_commission_report
      @commission_report = CommissionReport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def commission_report_params
      params.require(:commission_report).permit(:employee_name, :customer_name, :account_manager_id, :recruiter_id, :support_id, 
                    :pay_rate, :total_hours, :total_gross_pay, :total_bill, :am_rate, :rec_rate, :sup_rate, 
                    :mark_up, :week_ending, :week_beginning, :revenue, :am_amount, :rec_amount, :sup_amount, :customer_id)
    end
    
    def commission_report_import_params
        params.require(:commission_report_import).permit(:file)
    end
end
