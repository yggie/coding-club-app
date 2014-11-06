class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    access_token = request.env['omniauth.auth']
    @user = User.where(email: access_token.info['email']).first

    if @user
      sign_in_and_redirect @user, event: :authentication
    else
      info = access_token.info
      @user = User.new(email: info['email'],
                       name: info['name'],
                       first_name: info['first_name'],
                       last_name: info['last_name'],
                       profile_image_url: info['image'])

      if @user.save
        sign_in_and_redirect @user, event: :authentication
      else
        redirect_to new_user_session_path, flash: { danger: @user.errors.full_messages.join(', ') }
      end
    end
  end
end
