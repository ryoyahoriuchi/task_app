class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :basic_auth, :login_required

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["USERNAME"] && password == ENV["PASSWORD"]
    end
  end

  def login_required
    redirect_to new_session_path unless current_user
  end
end
