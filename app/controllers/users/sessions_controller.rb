# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  #POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?

   
    unless CompanyUser.find_by(user_id: current_user) == nil then
      unless (belonged_companies = CompanyUser.find_by(user_id: current_user).company.name) == nil then
        #所属するテナントに切り替え
        Apartment::Tenant.switch!(belonged_companies)
        #redirect_to('http://' + CompanyUser.find_by(user_id: current_user).company.name + '.' + request.domain, status: 301)
        redirect_to root_url(subdomain: "#{CompanyUser.find_by(user_id: current_user).company.name}")
      else
        redirect_to '/companies/new'
      end
    else
      redirect_to '/companies/new'
    end
      
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
