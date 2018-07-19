class Company < ApplicationRecord
  has_many :users, through: :company_users
  has_many :company_users
end
