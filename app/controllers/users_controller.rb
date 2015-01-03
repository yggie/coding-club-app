class UsersController < ApplicationController
  before_action :authenticate_user!

  def edit
  end

  def update
    if current_user.update_attributes(params.require(:user).permit(:subscription_preference))
      redirect_to edit_user_path, flash: { success: 'Your subscription preference has been updated' }
    else
      render :edit
    end
  end
end
