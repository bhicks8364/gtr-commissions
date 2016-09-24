# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  first_name             :string
#  last_name              :string
#  username               :string
#  role                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  advanced               :boolean          default(FALSE)
#  multi_rates            :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  include ArelHelpers::ArelTable
  include ArelHelpers::JoinAssociation
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  scope :account_managers, -> { where(User[:role].eq("Account Manager")) }
  scope :recruiters, -> { where(User[:role].eq("Recruiter").and(User[:username].not_eq("South").or(User[:username].not_eq("North").or(User[:username].not_eq("NorthWest"))))) }
  scope :support, -> { where(User[:role].eq("Recruiting Support")) }
  scope :admin, -> { where(User[:role].eq("Admin")) }

  def account_manager?; role == "Account Manager"; end
  def admin?; role == "Admin"; end
  def recruiter?; role == "Recruiter"; end
  def jonna?; username == "JonnaD"; end
  def lisa?; username == "LisaS"; end
  def house?; first_name == "House"; end
  def recruiting_support?; role == "Recruiting Support"; end

  def name
    first_name && last_name ? "#{first_name} #{last_name}" : username
  end
  
  def team?
    case username
    when "South"
        true
    when "North"
        true
    when "Sandusky"
        true
    else
        false
    end
  end
  
  def special?
    case username
    when "JonnaD"
        true
    when "JustinB"
        true
    when "BTowner"
        true
    when "KristenM"
        true
    when "ZacharyP"
        true
    else
        false
    end
  end
  
  # IMPORT FROM CSV
  def self.assign_from_row(row)
    user = User.new(email: row[:email], password: "111111", password_confirmation: "111111")
    user.assign_attributes row.to_hash.slice(:first_name, :last_name, :username, :role, :email)
    user.advanced = row[:advanced].starts_with?("y") ? true : false
    user
  end

  #  EXPORT TO CSV
  def self.to_csv
    attributes = %w{ first_name last_name name email username role }
    CSV.generate(headers: true) do |csv|
    csv << attributes
    
    all.each do |user|
    csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end
  
  def reports
    if account_manager?
      CommissionReport.includes(:account_manager, :recruiter, :support, :customer).where(account_manager_id: id)
    elsif recruiter?
      CommissionReport.includes(:account_manager, :recruiter, :support, :customer).where(recruiter_id: id)
    elsif recruiting_support?
      CommissionReport.includes(:account_manager, :recruiter, :support, :customer).where(support_id: id)
    else
      CommissionReport.none
    end
  end
  
  def customers
    if account_manager?
      Customer.joins(:commission_reports).where(CommissionReport[:account_manager_id].eq(id))
    elsif recruiter?
      Customer.joins(:commission_reports).where(CommissionReport[:recruiter_id].eq(id))
    elsif recruiting_support?
      Customer.joins(:commission_reports).where(CommissionReport[:support_id].eq(id))
    else
      Customer.none
    end
  end
  
  def current_report
    reports.current_week.last
  end
  
  def total_commission_amt(com_reports)
    case role
    when "Account Manager"
      com_reports.sum(:am_amount)
    when "Recruiter"
      com_reports.sum(:rec_amount)
    when "Recruiting Support"
      com_reports.sum(:sup_amount)
    end
  end
  
  def total_revenue(com_reports)
      com_reports.sum(:revenue)
  end
  def total_hours(com_reports)
      com_reports.sum(:total_hours)
  end
  def total_profit(com_reports)
      total_revenue(com_reports) / 2
  end
  
  def last_commission_week
    if reports.order(:week_ending).last.present?
      reports.order(:week_ending).last.week_ending.stamp("12/18/1989")
    else
      "No Records Found"
    end
  end
  
end
