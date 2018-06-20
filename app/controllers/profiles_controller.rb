class ProfilesController < ApplicationController

  def new
    @user = find_user
    @profile = Profile.new
  end

  def create
    @user = find_user
    @profile = @user.build_profile(set_params)
    if @profile.save
      flash[:success] = "Profile Updated!"
      redirect_to user_profile_path( params[:user_id] )
    else
      render action: :new
    end
  end

  def show
    @user = find_user
  end

  def edit
    @user = find_user
    @profile = @user.profile

  end


  private

  def find_user
      User.find(params[:user_id])
  end

  def set_params
    params.require(:profile).permit(:first_name,:last_name,:bio)
  end

end