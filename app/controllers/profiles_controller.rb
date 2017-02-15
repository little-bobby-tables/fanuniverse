class ProfilesController < ApplicationController
  before_action :load_user_and_profile, only: [:show]
  before_action :load_profile, only: [:edit, :update]

  def show
  end

  def edit
  end

  def update
    if @profile.update(profile_params)
      redirect_to profile_path(current_user), notice: 'Your profile was successfully updated.'
    else
      render :edit
    end
  end

  private

  def load_user_and_profile
    @user = User.where(name: params[:name]).eager_load(:profile).first or render_404
  end

  def load_profile
    @profile = current_user.profile
  end

  def profile_params
    params.require(:profile).permit(:bio)
  end
end
