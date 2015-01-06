class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    access_token = request.env['omniauth.auth']
    @user = User.where(email: access_token.info['email']).first

    if @user
      # TODO populate User information with updated info
      if @user.profile_image_url.blank?
        @user.update_attributes!(filter_attributes(access_token.info))
      end
      sign_in_and_redirect @user, event: :authentication
    else
      @user = User.new(filter_attributes(access_token.info))

      if @user.save
        sign_in_and_redirect @user, event: :authentication
      else
        redirect_to new_user_session_path, flash: { danger: @user.errors.full_messages.join(', ') }
      end
    end
  end

  def new_session_path(scope)
    new_user_session_path
  end

  private

  def filter_attributes(info)
    {
      email: info['email'],
      name: info['name'],
      first_name: info['first_name'],
      last_name: info['last_name'],
      profile_image_url: info['image'],
    }
  end
end
