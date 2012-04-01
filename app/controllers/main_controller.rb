class MainController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]

  def index
    redirect_to main_dashboard_path if user_signed_in?
  end

  def dashboard
  end
end
