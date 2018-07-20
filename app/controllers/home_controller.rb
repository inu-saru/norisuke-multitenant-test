class HomeController < ApplicationController
  def index
    @users = User.all if user_signed_in?
    @companies = Company.all
    @company_users = CompanyUser.all
  end
end