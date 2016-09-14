# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  name       :string
#  address    :string
#  state      :string
#  zipcode    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Customer < ActiveRecord::Base
  has_many :commission_reports
  
  def total_bill(week_ending)
    week = Chronic.parse(week_ending)
    commission_reports.where(week_ending: week).sum(:total_bill)
  end
  
  def account_manager
    commission_reports.last.account_manager if commission_reports.any?
  end
  
  def total_rev
    commission_reports.sum(:revenue)
  end
  
end
