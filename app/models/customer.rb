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
end
