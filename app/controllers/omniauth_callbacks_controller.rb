class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :omni_auth_actions


  def facebook
  end

  def twitter
  end

  def confirm_email
  end

  protected

  def omni_auth_actions
    @omni_auth = request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params[:auth])
    @user = User.find_for_oauth(@omni_auth)

    if @user && @user.persisted? && @user.confirmed?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message :notice, :success, kind: @omni_auth.provider.capitalize if is_navigational_format?
    end
    if @user && !@user.confirmed?
      render 'devise/confirmations/new'
    end
    unless @user
      render 'devise/registrations/confirm_email'
    end
  end
end