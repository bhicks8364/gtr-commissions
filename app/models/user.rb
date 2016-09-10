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
  scope :recruiters, -> { where(User[:role].eq("Recruiter")) }
  scope :support, -> { where(User[:role].eq("Recruiting Support")) }
  scope :admin, -> { where(User[:role].eq("Admin")) }
  scope :admin, -> {where(role: "Admin")}

  def account_manager?; role == "Account Manager"; end
  def admin?; email == "admin@email.com"; end
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
  
  # IMPORT FROM CSV
  def self.assign_from_row(row)
    user = User.new(email: row[:email], password: "111111", password_confirmation: "111111")
    user.assign_attributes row.to_hash.slice(:first_name, :last_name, :username, :role, :email)
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
    end
  end
  
  def current_report
    reports.current_week.last
  end
  
  def total_commission_amt
    case role
    when "Account Manager"
      reports.current_week.sum(:am_amount)
    when "Recruiter"
      reports.current_week.sum(:rec_amount)
    when "Recruiting Support"
      reports.current_week.sum(:sup_amount)
    end
  end
  
  def total_revenue
      reports.current_week.sum(:revenue)
  end
  def total_hours
      reports.current_week.sum(:total_hours)
  end
  def total_profit
      total_revenue / 2
  end
  
end
