class ApplicationController < ActionController::Base
  before_action :check_subdomain

  def check_subdomain
    return if request.subdomain == ""
    # システム管理者はどのテナントでもアクセスできる
    #return if current_user.sys_admin?
    # 自身の所属するサブドメイン以外のアクセスは許可しない
    if user_signed_in?
      unless CompanyUser.find_by(user_id: current_user) == nil
        unless (belonged_companies = CompanyUser.find_by(user_id: current_user).company.name) == nil
          return if request.subdomain == belonged_companies
        end
      end
    end
      redirect_to root_url(subdomain: "")
  end
end
