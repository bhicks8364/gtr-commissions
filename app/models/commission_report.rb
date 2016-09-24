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

class CommissionReport < ActiveRecord::Base
  include ArelHelpers::ArelTable
  include ArelHelpers::JoinAssociation
  
  before_save :calculate
  belongs_to :customer
  belongs_to :account_manager, class_name: "User", foreign_key: "account_manager_id"
  belongs_to :recruiter, class_name: "User", foreign_key: "recruiter_id"
  belongs_to :support, class_name: "User", foreign_key: :support_id
  
  scope :current_week, -> { where(CommissionReport[:week_ending].eq( Date.current.end_of_week - 1.week)) }
  
  # IMPORT FROM CSV
  def self.assign_from_row(row)
    commission = CommissionReport.new(employee_name: row[:employee])
    w = Chronic.parse(row[:week_ending]).present? ? Chronic.parse(row[:week_ending]).end_of_week : Date.current.end_of_week - 1.week
    commission.assign_attributes row.to_hash.slice(:customer_name, :account_manager, :recruiter, :recruiting_support, :pay_rate, :total_hours, :total_gross_pay, :total_bill, :start_date)
    if row[:double].starts_with?("y")
      commission.double = true
    end
    commission.account_manager = User.find_or_create_by(username: row[:created_by], role: "Account Manager")
    commission.recruiter = User.find_or_create_by(username: row[:assigned_by], role: "Recruiter")
    commission.support = User.find_or_create_by(username: row[:serviced_by], role: "Recruiting Support")
    commission.customer = Customer.find_or_create_by(name: row[:customer_name])
    commission.week_ending = w
    commission
  end
  
  #  EXPORT TO CSV
  def self.to_csv
    attributes = %w{ customer_name employee_name total_hours total_bill total_gross_pay mark_up revenue profit am_amount rec_amount sup_amount start_date pay_rate}
    CSV.generate(headers: true) do |csv|
    csv << attributes
    
    all.each do |commission|
    csv << attributes.map{ |attr| commission.send(attr) }
      end
    end
  end
  
  def set_revenue
    self.revenue = total_bill - total_gross_pay
  end
  
  
  def self.calculate_all!
    all.each do |commission|
      commission.calculate
      commission.save
    end
  end
  
  def calculate
    set_revenue
    if recruiter.present? && recruiter.advanced?
      self.rec_rate = adv_recruiter_rate
    else
      self.rec_rate = recruiter_rate
    end
    
    if double?
      self.sup_rate = rec_support_rate * 2
    else
      self.sup_rate = rec_support_rate
    end
    self.am_rate = acct_manager_rate
    set_amounts
    self.week_beginning = week_ending.beginning_of_week
    self.mark_up = (total_bill / total_gross_pay).round(2)
    self.customer = Customer.find_or_create_by(name: customer_name)
  end

  def profit
    revenue / 2
  end

  def commission_total(rate)
    if profit.present? && rate.present?
      profit * rate
    else
      0
    end
  end


  def recruiter_rate
      if recruiter.present? && recruiter.house?
          0.02
      elsif recruiter.present? && recruiter.team?
          0.02
      elsif recruiter.present? && recruiter.lisa?
          0.05
      else
          case pay_rate
          when (0...9.99)
              0.025
          when (10...15.99)
              0.05
          when (16...21.99)
              0.075
          when (22...300)
              0.1
          end
      end
  end
  
  def rec_support_rate
      case pay_rate
      when (0..10.00)
        0.01
      when (10.01..12.00)
        0.02
      when (12.01..300)
        0.03
      end
  end
  
  def adv_recruiter_rate
      if recruiter.reports.current_week.sum(:total_hours) <= 1000
          case pay_rate
          when (0..15.99)
              0.075
          when (16..21.99)
              0.1
          when (22..30)
              0.125
          when (30..300)
              0.15
          end
      elsif recruiter.reports.current_week.sum(:total_hours) > 1000 && recruiter.reports.current_week.sum(:total_hours) < 1500
          case pay_rate
          when (0..15.99)
              0.1
          when (16..21.99)
              0.125
          when (22..30)
              0.15
          when (30..300)
              0.175
          end
      elsif recruiter.reports.current_week.sum(:total_hours) > 1501 && recruiter.reports.current_week.sum(:total_hours) < 2000
          case pay_rate
          when (0..15.99)
              0.125
          when (16..21.99)
              0.15
          when (22..30)
              0.175
          when (30..300)
              0.2
          end
      elsif recruiter.reports.current_week.sum(:total_hours) > 2000
          case pay_rate
          when (0..15.99)
              0.15
          when (16..21.99)
              0.175
          when (22..30)
              0.2
          when (30..300)
              0.2 # This will need changed
          end
      end
  end
  def special_rec_rate
      case pay_rate
      when (0...9.99)
          0.025
      when (10...15.99)
          0.05
      when (16...21.99)
          0.075
      when (22...300)
          0.1
      end
  end
  
  def acct_manager_rate
    # def acct_manager_rate(com_reports) # Feeling like this is how it should be... not sure.
    if account_manager.present?
      total_hrs = account_manager.reports.current_week.sum(:total_hours)
      # total_hrs = com_reports.sum(:total_hours)
      if account_manager.special?
          special_rec_rate
      elsif total_hrs < 1000
          0.025
      elsif total_hrs > 1000 && total_hrs < 2000
          0.03
      elsif total_hrs > 2000 && total_hrs < 3000
          0.035
      elsif total_hrs > 3000 && total_hrs < 4000
          0.04
      elsif total_hrs > 4000 && total_hrs < 5000
          0.045
      elsif total_hrs > 5000
          0.05
      else
          0.025
      end
    end
  end
  
  def set_amounts
    self.am_amount = commission_total(acct_manager_rate)
    self.sup_amount = commission_total(sup_rate)
    if recruiter.present? && recruiter.advanced
      self.rec_amount = commission_total(adv_recruiter_rate)
    else
      self.rec_amount = commission_total(recruiter_rate)
    end
  end
end
