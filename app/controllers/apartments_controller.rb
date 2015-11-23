class ApartmentsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    authenticate_user! # include in before_action on line 3
    @user = current_user
    if current_user
      @apartment = current_user.apartment
    else
      redirect_to new_user_session_path
    end
  end

  def new
    @apartment = Apartment.new
  end

  def create
    @apartment = Apartment.new(apartment_params)
    unless @apartment.save
      redirect_to new_apartment_path
    end
    @apt_id = @apartment.id
    current_user.apartment_id = @apt_id
    # or current_user.aparement.create...
    if current_user.save
      redirect_to apartment_path (@apartment)
    end
  end

  def show
    @apartment = Apartment.find(params[:id])
    @roommates = @apartment.users
    user = current_user
    @roommate_sums = []
    unless @apartment.expenses.nil?
      @expenses = current_user.expenses
      @roommate_sums = roommate_sums
      @grand_total = get_total
      # I recommend moving the 3 above methods
      # to your model definition for apartments.
      # This will allow you to reuse the `unless` block
      # and access data from view like
      # @apartment.expenses
      # @apartment.roomate_sums
      # @apartment.grand_total
      # without bloating your controllers
    end
  end

  def edit
    @apartment = Apartment.find(params[:id])
    @roommates = @apartment.users
  end

  def update
    @user = current_user
    @apartment.update(apartment_params)
    if @apartment.update(apartment_params)
      flash[:notice] = "You have successfully update this apartment."
    end
    redirect_to apartment_path(@apartment)
  end

  def destroy
    @apartment.destroy
    redirect_to apartment_path
  end

  def get_total
    @apartment = Apartment.find(params[:id])
    unless @apartment.expenses.nil?
      @apartment.expenses.map {|expense| expense.amount}.reduce(:+)
    end
  end

  def roommate_sums
    @apartment = Apartment.find(params[:id])
    unless @apartment.expenses.nil?
      users = @apartment.users
      apartment_total = get_total
      apartment_average = (apartment_total / users.length)
      roommate_sums = []
      users.each do |user|
        total = user.expenses.map {|expense| expense.amount}.reduce(:+)
        balance = apartment_average - total
        roommate_sums << {:total => total, :balance => balance, :user => user}
      end
    end
    return roommate_sums
  end

  def clean_slate
   @apartment = current_user.apartment
   expenses = @apartment.expenses
   expenses.each do |expense|
     expense.delete
   end
   # or @apartment.expenses.destroy_all
   redirect_to apartment_path(@apartment)
  end

  private
    def apartment_params
      params.require(:apartment).permit(:name)
    end

    def set_post
      @apartment = Apartment.find(params[:id])
    end

    # also re: your comment in submission form, you might want to
    # introduce some more robust error handling to prevent the math errors,
    # as we did in https://github.com/ga-dc/curriculum/tree/0f4376c51a4d28bf81456c3e86706a469c42659f/05-mvc-with-rails/error-handling#beginrescue-time-permitting-15-min

end
