

class ProfilesController < ApplicationController
  before_action :authenticate_user!
  # before_action :only_current_user

  def index
    if params[:name] && params[:name] != ""
      names = params[:name].split(" ")
      f_name = "%#{names.first}%"
      l_name = "%#{names.last}%"
      @profiles = Profile.where("first_name LIKE ? OR last_name LIKE ?", f_name, l_name)
      if @profiles.count == 1
        redirect_to user_profile_path(@profiles.first)
      end
    else
      @profiles = Profile.all
    end
  end

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
    @users = User.all
    set_current_room
    @message = Message.new
    @messages = current_room.messages if current_room
    @friends = @user.all_friends
    @articles = current_user.get_feed
    @articles = @user.articles if @articles.empty?
  end

  def edit
    @user = find_user
    @profile = @user.profile
  end

  def update
    @user = find_user
    @profile = @user.profile
    if @profile.update(set_params)
      flash[:success] = "Profile Updated!"
      redirect_to user_profile_path( params[:user_id] )
    else
      render action: :edit
    end
  end


  private

  def only_current_user
    @user = find_user
    redirect_to(root_path) unless @user == current_user
  end

  def set_current_room
       # @room = current_user.profile.room
    if params[:room_id]
      @room = Room.find_by(id: params[:room_id])
    else
      @room = current_user.profile.room #this line of code may be my issue
    end
    session[:current_room] = @room.id if @room
  end

  def find_user
      User.find(params[:user_id])
  end

  def set_params
    params.require(:profile).permit(:first_name, :last_name, :bio, :avatar)
  end

end
