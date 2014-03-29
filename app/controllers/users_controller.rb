class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_filter :authenticate_user!

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end
    
  def submitted_translations
    @translations = Translation.where(user_id: params[:id])
    
    render "translations/submited"
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name)
    end
end
