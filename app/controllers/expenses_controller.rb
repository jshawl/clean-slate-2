class ExpensesController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    authenticate_user!
    @user = current_user
    if current_user
      @expenses = current_user.expenses
    else
      redirect_to new_user_session_path
    end
  end

  def show
  end

  def new
      @roommate = current_user.first_name
      @expense = Expense.new
  end

  def create
      @apartment = current_user.apartment
      current_user.expenses.create(expense_params)
      redirect_to apartment_path(@apartment), notice: "This expense was successfully created!"
  end

  def edit
    @user = current_user
  end

  def update
    @apartment = current_user.apartment
    @user = current_user
    @expense.update(expense_params.merge(user: current_user))
    if @expense.update(expense_params)
      flash[:notice] = "You have successfully update this expense"
    end
    redirect_to apartment_path(@apartment)
  end

  def destroy
    @apartment = current_user.apartment
    @expense.destroy
    # ^^ can you think of a way to restrict deleting expenses to the person who created it?
    redirect_to apartment_path(@apartment)
  end

  private
  def expense_params
    params.require(:expense).permit(:created_at, :amount, :description, :user_first_name)
    # instead of user_first_name, can you use current_user?
  end

  def set_post
    @expense = Expense.find(params[:id])
  end

end
