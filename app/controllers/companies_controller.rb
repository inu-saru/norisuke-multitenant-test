class CompaniesController < ApplicationController
  before_action :authenticate_user!, only: [:new]

  def index
    @companies = Company.all
    #Apartment::Tenant.switch!('company3')
    @current_tenant = Apartment::Tenant.current
    #@company = Company.find(1)
    #redirect_to @company
  end

  def show
    @company = Company.find(params[:id])
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      #CompanyとCompanyUserの関連付け
      company_user = CompanyUser.new(user_id:current_user.id, company_id:@company.id)
      company_user.save
      #テナントを作成します。サブドメイン作る
      tenant_name = @company.name
      Apartment::Tenant.create(tenant_name)
      #作成したテナントに切り替え
      Apartment::Tenant.switch!(tenant_name)
      redirect_to root_url(subdomain: "#{tenant_name}")
    else
      render 'new'
    end
  end

  private

    def company_params
      params.require(:company).permit(:name)
    end
end
