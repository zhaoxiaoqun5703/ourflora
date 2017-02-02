class AccountsController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  
  def index
    @accounts = Account.all
  end

  def new
    @account = Account.new
  end

  def show
    @account = Account.find(params[:id])
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      log_in @account
      redirect_to @account
    else
      render 'new'
    end
  end

  def edit
      @account = Account.find(params[:id])
  end

  def update
    @account = Account.find(params[:id])
    if @account.update_attributes(account_params)
      # Handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to @account
    else
      render 'edit'
    end
  end

  def destroy
      Account.find(params[:id]).destroy
      flash[:success] = "User deleted"
      redirect_to accounts_url
  end

  private
    def account_params
      params.require(:account).permit(:name, :email, :password, :password_confirmation)
    end

    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @account = Account.find(params[:id])
      unless @account == current_user
        flash[:danger] = "Access denied."
        redirect_to(login_url)
      end
    end
end
