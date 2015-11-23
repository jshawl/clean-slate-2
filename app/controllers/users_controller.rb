class UsersController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]


  def index
    @expenses = current_user.expenses
    @apartment = current_user.apartment
  end

  def new
    @user = User.new
  end

  def create

  end

  def show
    temp_id = current_user.temp_id
    apartment = Apartment.where(params[:id] == temp_id)
    @apartment = apartment.name
    @user = current_user.first_name
  end

  def update
    @apartment = current_user.apartment.name
    if current_user.apartment_id
      redirect_to apartment_path(@apartment)
    end
  end

  def invite_roommate
    user = User.find_by(email: params[:email])
    user.temp_id = current_user.apartment_id
    user.save
    # excellent implementation! It would be nice if you sent an email when an invite is
    # sent to a user - http://guides.rubyonrails.org/action_mailer_basics.html
    @apartment = current_user.apartment_id
    redirect_to apartment_path(@apartment), notice: "You have successfully invited this roommate. Your roommate must log-in to accept or decline your invitation."
  end

  def accept_invite
    current_user.apartment_id = current_user.temp_id
    current_user.save
    current_user.temp_id = nil
    current_user.save
    redirect_to apartment_path(current_user.apartment), notice: "You have successfully joined as a roommate!"
  end

  def decline_invite
    redirect_to new_apartment_path
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :encrypted_password, :temp_id) 
    # I recommend removing temp_id from your strong params and instead getting this from the URL
    # or a session variable.
  end

  def set_post
    @user = User.find(params[:id])
  end
end
