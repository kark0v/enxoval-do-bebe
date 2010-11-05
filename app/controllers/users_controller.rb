class UsersController < ApplicationController
  before_filter :login_required, :except => [:new, :create]

	def show
		@user = User.find(params[:id])
	end

	def index
		@users = User.all
	end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
			if current_user && current_user != @user
				flash[:notice] = "Utilizador registado com sucesso."
				redirect_to users_path
			else
	      session[:user_id] = @user.id
	      flash[:notice] = "Thank you for signing up! You are now logged in."
  	    redirect_to "/"
			end
    else
      render :action => 'new'
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Your profile has been updated."
      redirect_to @user
    else
      render :action => 'edit'
    end
  end
end
