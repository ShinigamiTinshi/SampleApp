class AdminController < ApplicationController
  before_action :admin?
  layout 'admin'

  def users_count
    @users_count = User.count
  end
end
